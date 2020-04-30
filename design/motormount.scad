L=25.4;

D1=16.8+0.3;
D2=16.0+0.3;
H1=12.0;
H2=43.0;
X1=13.5+0.3;
W1=2.5+1.0;
W2=5;
Q=2.8+6;

/*translate([0,-L/8,-L/8])
cube([H2+W1+5+12+4,L/4,L/8]);*/
difference() {
    //translate([0,-L/2,0])
    //cube([H2+W1+W2+12+4,L,Q]);
    difference() {
        rotate([0,90,0])
        cylinder(d=L,H2+W1+W2+12+4,$fn=256);
        scale([1,1,-1])
        cube_center([200,200,200]);
        translate([0,0,Q])
        cube_center([200,200,200]);
    }
    
    translate([0,0,1]) {
        
    translate([-0.001,0,D1/2+0.0])
    rotate([0,90,0])
    shaft();
    
    translate([-0.001,0,D1/2+0.0])
    rotate([0,90,0])
    cylinder(d=10,h=100,$fn=128);
    }
    
    translate([52,0,0]) {
        cylinder(d=L/4+0.3,h=100,$fn=128);
        translate([0,0,1])
        cylinder(d=11.5,h=3,$fn=128);
    }
    
    translate([25,0,0]) {
        cylinder(d=L/4+0.3,h=100,$fn=128);
        translate([0,0,1])
        cylinder(d=11.5,h=3,$fn=128);
    }
}
   

/*
difference() {
    translate([0,-L/2,0])
    cube([43+2.5+5+12+4,L,4.5]);
    
    translate([0,0,16.8/2+0.5])
    rotate([0,90,0])
    shaft();
}*/

module shaft() {
    cylinder(d=D1,h=H1+.001,$fn=256);
    translate([0,0,12])
    difference() {
        cylinder(d=D2,h=H2+W1+W2,$fn=256);
        translate([X1-D2/2,0,H2/2+W2])
        rotate([0,90,0])
        cube_center([H2,100,100]);
    }
}

//cube_center([L,L,L]);

module cube_center(dims) {
    translate([-dims[0]/2, -dims[1]/2, 0])
    cube(dims);
}