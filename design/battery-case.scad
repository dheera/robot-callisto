L1=135;
L2=68;
W1=43;
W2=19;
H=77;
T=3;

difference() {
    minkowski() {
        linear_extrude(height=H+T)
        battery_shape();
        cylinder(d=2*T,h=0.001,$fn=64);
    }
    translate([0,0,H])
    minkowski() {
        linear_extrude(height=H+T)
        battery_shape();
        cylinder(d=T,h=0.001,$fn=64);
    }
    
    translate([0,0,T])
    linear_extrude(height=H)
    battery_shape();
}

translate([0,80,0])
difference() {
    minkowski() {
        linear_extrude(height=5+T)
        battery_shape();
        cylinder(d=2*T,h=0.001,$fn=64);
    }
    
    translate([0,0,5])
    difference() {
        minkowski() {
            linear_extrude(height=5+T)
            battery_shape();
            cylinder(d=2*T,h=0.001,$fn=64);
        }
        minkowski() {
            linear_extrude(height=5+T)
            battery_shape();
            cylinder(d=T,h=0.001,$fn=64);
        }
    }
    
    translate([0,0,T])
    linear_extrude(height=15)
    battery_shape();
    
    translate([0,10,0])
    cube_center([10,17,10]);
}

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


module cube_center(dims) {
    translate([-dims[0]/2, -dims[1]/2, 0])
    cube(dims);
}