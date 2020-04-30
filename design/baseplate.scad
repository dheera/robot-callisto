W = 5.0 * 25.4;
L = 8.5 * 25.4;

Q = 1 * 25.4;

difference() {
    cube_center([L, W,2]);
    
    translate([0,-W/2,0])
    for(i = [-80:10:80]){
        for(j = [5:10:95]){
            if(!((1==2) && j==45)) {
                translate([i,j,0])
                cylinder(d=1.7,h=3,$fn=16);
            }
        }
    }
    
    translate([-L/2+Q/2+Q,W/2-Q/2,0])
    cube_center([Q,Q,5]);
    translate([-(-L/2+Q/2+Q),W/2-Q/2,0])
    cube_center([Q+0.5,Q+0.5,5]);
    
    translate([0,W/2-Q/2,0])
    cube_center([Q*(1.5)+0.5,Q+0.5,5]);
    
    
    translate([-Q*1.5,W/2-Q/2,0])
    cylinder(d=1/4*25.4+1,h=20,$fn=32);
    translate([Q*1.5,W/2-Q/2,0])
    cylinder(d=1/4*25.4+1,h=20,$fn=32);
    
    
    translate([L/2-Q/2,W/2-Q/2-Q,0])
    cylinder(d=1/4*25.4+1,h=20,$fn=32);
    translate([-(L/2-Q/2),W/2-Q/2-Q,0])
    cylinder(d=1/4*25.4+1,h=20,$fn=32);
    
    translate([L/2-Q/2,W/2-Q/2-3.5*Q,0])
    cylinder(d=1/4*25.4+1,h=20,$fn=32);
    translate([-(L/2-Q/2),W/2-Q/2-3.5*Q,0])
    cylinder(d=1/4*25.4+1,h=20,$fn=32);
    
    /*
    translate([Q*1.5,W/2-Q/2,0])
    cylinder(d=1/4*25.4+1,h=20,$fn=32);
    */
    
    /*
    for(i=[-90:20:90]) {
        translate([i,50,0])
        cylinder(d1=3.5,d2=6,h=2,$fn=16);
    }
    for(j=[-45:20:35]) {
        translate([-105,j,0])
        cylinder(d=3.5,d2=6,h=2,$fn=16);
    }
    for(j=[-45:20:35]) {
        translate([105,j,0])
        cylinder(d1=3.5,d2=6,h=2,$fn=16);
    }
    
    */
    /*
    translate([-105,50,0])
    cube_center([10,10,3]);
    
    translate([105,50,0])
    cube_center([10,10,3]);
    
    translate([50,35,0])
    cube_center([12,12,3]);
    
    translate([-50,35,0])
    cube_center([12,12,3]);
    
    translate([90,-5,0])
    cube_center([12,12,3]);
    
    translate([-90,-5,0])
    cube_center([12,12,3]);
    
    translate([0,-5,0])
    cube_center([12,12,3]);
    */
    
    translate([55,-W/2,0])
    cylinder(d=25,h=3);
    
    translate([-55,-W/2,0])
    cylinder(d=25,h=3);
    
}


module cube_center(dims) {
    translate([-dims[0]/2, -dims[1]/2, 0])
    cube(dims);
}