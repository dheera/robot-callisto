L1=135;
L2=68;
L3=8.5*25.4;
W1=43;
W2=19;
H=2*25.4*0.625;
T=3;

difference() {
    
    minkowski() {
        linear_extrude(height=(H+T)/2)
        battery_shape2();
        cylinder(d=3*T+0.5,h=0.001,$fn=64);
    }
    
    translate([0,0,T/2])
    minkowski() {
        linear_extrude(height=(h+T)/2)
        battery_shape2();
        cylinder(d=2*T+0.5,h=0.001,$fn=64);
    }

    translate([0,0,0])
    minkowski() {
        linear_extrude(height=(h+T)/2)
        battery_shape2();
        
        // cylinder(d=2*T+0.5,h=0.001,$fn=64);
    }    
    /*
    translate([0,0,T])
    linear_extrude(height=H)
    battery_shape();
    */
    
    
    translate([-L3,W1+31.4-T,0])
    cube([L3*2,L3*2,L3]);
    
    translate([L3/2,0])
    cube([L3*2,L3*2,L3]);
    
    scale([-1,1,1])
    translate([L3/2,0])
    cube([L3*2,L3*2,L3]);
    
    
    for(s=[-1:2:1])
    translate([s*(8.5*25.4/2-0.5*25.4),0,(H+T)/2/2])
    rotate([90,0,0])
    cylinder(d=0.25*25.4+0.2,h=2*L3,center=true,$fn=32);
}

        translate([-L1/2,W1-10,0])
        cube([L1,5,T/2]);

        translate([-L1/2,(W1-10)/2,0])
        cube([L1,5,T/2]);

        translate([-L1/2,0,0])
        cube([L1,5,T/2]);

//translate([-L3/2,W1+25.4*2,0])
//cube([L3,T/2,(H+2*T)/2]);

/*
translate([-L3/2,W1+25.4*1.25,0])
cube([L3,T/2,(H+2*T)/2]);
*/

/*
translate([0,100,0])
battery_shape2();
*/
module battery_shape2() {
    polygon([
[-L1/2,0],
[-L2/2,-W2],
[L2/2,-W2],
[L1/2,0],
[L1/2,W1],
[L3/2-25.4,W1+31.4],
[L3/2,W1+31.4],
[L3/2,W1+31.4+10],
[-L3/2,W1+31.4+10],
[-L3/2,W1+31.4],
[-L3/2+25.4,W1+31.4],
[-L1/2,W1],
]);
};


module battery_shape () {
    polygon([
[-L1/2,0],
[-L2/2,-W2],
[L2/2,-W2],
[L1/2,0],
[L1/2,W1],
[-L1/2,W1],
]);
};