L1=51.5;
W1=16.25;

difference() {
minkowski() {
translate([-(L1)/2,-(W1-4)/2])
cube([L1,W1-4,2]);
cylinder(d=6,h=0.0001,$fn=32);

}


for(i=[-20:10:20]) {
translate([i,0,0])
cylinder(d=2,h=4,$fn=16);
}



/*
translate([L1/2,W1/2,0])
standoffh();
translate([L1/2,-W1/2,0])
standoffh();
translate([-L1/2,W1/2,0])
standoffh();
translate([-L1/2,-W1/2,0])
standoffh();*/
}

//cube([L1,W1,9], center=true);

translate([-L1/2-2,-(W1/2)/2,2])
cube([2,W1/2,3]);

translate([L1/2,-(W1/2)/2,2])
cube([2,W1/2,3]);

translate([-L1/2,-W1/2-1,0])
cube([L1,1,6.13]);
translate([-L1/2,W1/2,0])
cube([L1,1,6.13]);

translate([-L1/2,-(W1-2)/2-2,0])
cube([L1,3,4]);
translate([-L1/2,(W1-2)/2-1,0])
cube([L1,3,4]);
difference() {
    union() {
translate([0,W1/2,5.75])
rotate([0,90,0])
cylinder(d=1.5,h=L1,$fn=3,center=true);

translate([0,-W1/2,5.75])
rotate([0,90,0])
cylinder(d=1.5,h=L1,$fn=3,center=true);
    }
    
    cube([L1*3/4,W1*2,20],center=true);
}

/*
translate([-L1/2,W1/2,0])
standoff();
translate([L1/2,-W1/2,0])
standoff();
translate([-L1/2,-W1/2,0])
standoff();
translate([L1/2,W1/2,0])
standoff();*/

module standoff() {
    difference() {
        cylinder(d1=6,d2=4,h=5,$fn=64);
        cylinder(d=1.8,h=6,$fn=32);
    }
}

module standoff2() {
        cylinder(d1=6,d2=4,h=5,$fn=64);
        cylinder(d=2.1,h=6.5,$fn=32);
}

module standoffh() {

        cylinder(d=1.8,h=6,$fn=32);
}