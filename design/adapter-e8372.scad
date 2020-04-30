L=78.25;
W=29.7;
H=15;
L1=5;
W1=27;
H1=11;
T=1.5;

translate([0,W/2,H+T/2])
rotate([0,90,0])
cylinder(d=3,h=L,$fn=3);

translate([0,-W/2,H+T/2])
rotate([0,90,0])
cylinder(d=3,h=L,$fn=3);

difference() {
    translate([(L+T)/2,0,0])
    cube_center([L+T,W+2*T,H+T]);

    translate([(L-5)/2,0,T])
    cube_center([L-5,W-10,H]);
    
    translate([0,0,2]) {
        
    translate([L1 + (L-L1)/2,0,T])
    cube_center([L-L1,W,H]);
    
    translate([L1/2,0,T+(H-H1)/2])
    cube_center([L1,W1,H]);    
    
    translate([22,0,9])
    rotate([90,0,0])
    cube_center([15,10,100]);
    
    translate([61,0,9])
    rotate([90,0,0])
    cube_center([15,10,100]);
    }
    
    for(i=[5:10:70]) {
        for(j=[-5:10:5]) {
            translate([i,j,0])
            cylinder(d=2,h=4,$fn=16);
        }
    }
    
}



module cube_center(dims) {
    translate([-dims[0]/2, -dims[1]/2, 0])
    cube(dims);
}