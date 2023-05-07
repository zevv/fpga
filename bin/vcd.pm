
package vcd;

use strict;
use IO::File;

# Create a new VCD object. Opens the given file and reads the headers with
# the signal info database and initial values

sub new
{
	my($class, $fname) = @_;
	my($self) = {};

	$self->{fd} = new IO::File($fname);
	unless(defined($self->{fd})) {
		print "Can't open '$fname' : $!\n";
		return;
	}

	bless($self, $class);
	$self->step();
	return($self);
}


# step() reads the VCD file until the next timestep is found. On the way it
# collects all the signal information like names and initial values.

sub step
{
	my($self) = @_;
	my($fd, $l, $name);

	# Update the 'prev' value for signals which have changed during the
	# previous timestep

	foreach $name ( keys %{%$self->{needupdate}} ) {
		$self->{info}->{$name}->{prev}  = $self->{info}->{$name}->{value};
		delete $self->{needupdate}->{$name};
	}

	# Read until next time marker reached

	$fd = $self->{fd};
	$self->{stepping} = 1;

	while($self->{stepping}) {

		$l = <$fd>;
		return 0 unless(defined($l));

		if(substr($l, 0, 1) eq '$') {
			if( $l =~ /^\$(\S+)\s*(.*)\s\$end$/) {
				$self->_parse_line($1, $2);
			} elsif ( $l =~ /^\$end$/) {
				$self->{section} = "";
			} elsif ( $l =~ /^\$(\S+)/) {
				$self->{section} = $1;
			}
		} else {
			$self->_parse_line($self->{section}, $l);
		}
	}
	
	
	return 1;
}


# Return an array describing all known signals.

sub signals
{
	my($self) = @_;
	my($name, @list);

	foreach $name ( keys %{%$self->{info}} ) {
		push @list, $self->{info}->{$name};
	}
	
	return @list;
}


# Return the current time

sub time
{
	my($self) = @_;
	return $self->{time};
}


# Return the current value of the given signal

sub value
{
	my($self, $name ) = @_;
	return ($self->{info}->{$name}->{value}); 
}


# Return the bits of the signal that have changed the last timestep

sub changed
{
	my($self, $name ) = @_;
	return $self->{info}->{$name}->{prev} ^ $self->{info}->{$name}->{value};
}


# Return the bits that went from lo to hi during the last timestep

sub posedge
{
	my($self, $name ) = @_;
	return ~$self->{info}->{$name}->{prev} & $self->{info}->{$name}->{value};
}


# Return the bits that went from hi to lo during the last timestep

sub negedge
{
	my($self, $name ) = @_;
	return $self->{info}->{$name}->{prev} & ~$self->{info}->{$name}->{value};
}


########################################################################
# Interal methods
########################################################################

sub _parse_line
{
	my($self, $section, $data) = @_;
	
	if ( ($section eq "") or ($section eq "dumpvars") ) {
		if    ( $data =~ /^([01xz])(.)/ )  { $self->_setvar($2, $1); }
		elsif ( $data =~ /^(\S+) (\S+)$/ ) { $self->_setvar($2, $1); }
		elsif ( $data =~ /^#(.+)/ )        { $self->_settime($1); }
		else  { chomp $data; print "Don't understand '$data', line $.\n"; }
	}
	
	elsif ( $section eq "var" ) {
		my ($type, $width, $char, $name, $range) = split / +/, $data;
		$self->_addvar($name, $char, $type, $width, $range);
	}
}


sub _setvar
{
	my($self, $char, $val) = @_;
	my($name);

	# We dont do x and z, map those to '0'

	$val =~ s/xz/0/g;	

	# Check for binary notation

	if(substr($val, 0, 1) eq "b") {
		$val = oct("0b" . substr($val, 1));
	} else {
		$val = $val+0;
	}
	
	$name = $self->{charname}->{$char};
	$self->{info}->{$name}->{value} = $val;
	$self->{needupdate}->{$name} = 1;
}


sub _addvar
{
	my($self, $name, $char, $type, $width, $range) = @_;
	
	$self->{info}->{$name}->{name}  = $name;
	$self->{info}->{$name}->{char}  = $char;
	$self->{info}->{$name}->{type}  = $type;
	$self->{info}->{$name}->{width} = $width;
	$self->{info}->{$name}->{range} = $range;
	$self->{charname}->{$char} = $name;
}


sub _settime
{
	my($self, $time) = @_;
	$self->{time} = $time;
	$self->{stepping} = 0;
}



1;

__END__

=head1 NAME

vcd - easy parsing of VCD (value change dump) wave files

=head1 SYNOPSYS

  use vcd;

  $v = new vcd("vga.vcd");

  while($v->step) {
	if($v->posedge('clk')) {
		print $v->value('pixel') ? "#" : " ";
	}
	if($v->posedge('hsync')) {
		print "\n";
	}
  }


=head1 DESCRIPTION

vcd.pm is a simple perl module for parsing VCD files. It provides a object interface to
step through a VCD file, and inspect signal levels and transitions.

=head1 CONSTRUCTOR

=over

=item new(filename)

This creates a new vcd parse object, and opens the given VCD file. The headers of the
file containing the signal names and descriptions is parsed, and the initial signal
values are read.

=back

=head1 METHODS

=over

=item step

Proceed to the next timestep in the vcd file. Returns 0 if EOF reached.

=item time

Return the current time

=item value( signame )

Return the current value of the given signal. If the signal is a bus, the
decimal value of the whole bus is returned.

=item posedge( signame )

Return the bits from the given signal which went from low to high during the
last timestep

=item negedge( signame )

Return the bits from the given signal which went from high to low during the
last timestep

=item changed( signame )

Return the bits from the given signal which changed during the last timestep

=item signals

Returns an array of hashes describing all signals from the VCD file. The keys of this hash are :

        'name' 		The signal's name
        'width' 	The width of the signal, in bits
        'type' 		Signal type <wire/reg/...>
	'char'		The VCD character representation of this signal
	'value'		Current value of the signal

=back

=head1 BUGS AND KNOWN ISSUES

=over

=item * Only tested with VCD files created by I<iverilog> and I<cver>

=item * Undefined (x) and High-impedance (z) values are not properly handled

=item * The performance is poor.

=back

=head1 AUTHOR

Ico Doornekamp