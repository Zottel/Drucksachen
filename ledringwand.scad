cm=10;

printing = true;

segments = 16;
segment_height = 1.5*cm;
cover_height= 0.5*cm;
inner_radius = 2.5*cm;
outer_radius = 3.5*cm;

wall_width=0.1*cm;
$fn = segments;

// Generic Ring builder
module in_ring(radius, times) {
    for(i=[0:times-1]) {
        rotate([0,0,(360/times)*i], center=true)
        translate([0,radius])
        children();
    }
}

module segmentation() {
	// bottom plate
	linear_extrude(height=wall_width)
		difference() { circle(outer_radius); circle(inner_radius); };
	
	// inner ring
	linear_extrude(height=(segment_height+wall_width))
	difference() {
		circle(inner_radius);
		circle(inner_radius-wall_width);
	};
	
	// dividers
	translate([0,0,wall_width])
	linear_extrude(height=segment_height)
		in_ring((inner_radius+outer_radius)/2, segments)
			square([wall_width, (outer_radius-inner_radius)], center=true);
};

module cover() {
	// outer ring
	translate([0,0,wall_width])
	linear_extrude(height=cover_height) {
		difference() { circle(outer_radius); circle(outer_radius - wall_width); };
		difference() { circle(inner_radius); circle(inner_radius - wall_width); };
	};
	linear_extrude(height=wall_width){
		circle(outer_radius);
	};
};




segmentation();

if(printing) {
	translate([0,outer_radius*2.1,0])
	cover();
} else {
	translate([0,0,segment_height+wall_width])
	rotate([0,180,0])
	cover();
}

