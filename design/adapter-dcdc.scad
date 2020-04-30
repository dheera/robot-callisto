L1=40;
W1=53.5;
W2=53.5;

difference() {
    
    union() {
    
    minkowski() {
        translate([-L1/2,-W1/2])
        cube([L1,W1,2]);
        
        cylinder(d=9,h=0.0001,$fn=32);
    }

    for(s=[-1:2:1])
    translate([0,s*W2/2,0])
    difference() {
        minkowski() {
            translate([-40/2,0,0])
            cube([40,0.001,4.3]);
    
            cylinder(d=4,h=0.001,$fn=32);
        }

        cylinder(d=10,h=6,$fn=64);
    
    }
}


    for(i=[-2:2]) {
        for(j=[-2:2]) {
      
            if(!(abs(i)==4 && abs(j)==3)) {
                translate([i*10,j*10,0])
                cylinder(d=2,h=4,$fn=16);
            }
        
        }
    }
    
    minkowski() {
        translate([-L1/2+7,-W1/2+7])
        cube([L1-14,W1-14,2]);
        
        cylinder(d=6,h=0.0001,$fn=32);
    }

        translate([0,-W2/2,0])
        standoffh();
        
        translate([0,W2/2,0])
        standoffh();
}

    translate([0,-W2/2,0])
    standoff();
    
    translate([0,W2/2,0])
    standoff();



module standoff() {
    difference() {
        cylinder(d1=10,d2=10,h=4,$fn=64);
        cylinder(d=4.8,h=4,$fn=32);
    }
}
module standoffh() {
        cylinder(d=6,h=6,$fn=32);
}