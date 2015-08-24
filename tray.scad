/*
The MIT License (MIT)

Copyright (c) 2014 Julien TERRAZ @targz

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

include <MyOpenScadLibs/round/cube.scad>;

// general
ballDiam = 10.2;
armDiam = 4.7;
armLength = 15; // default 8
trayMainDiam = 8.4;
traySmallDiam = 4.3;

// Tray
trayX = 15.8;
trayY = 11;
trayZ = 7.5;
trayRad = 5;
trayCurve = 3.4;

// Box
boxX = 8;
boxY = 4;
boxZ = trayZ;
boxRadius = 1;
sideExtrudeHeight=4;


$fn=50;

module trayMainDiamExtruder(delta){
    translate([7,6+delta,trayZ/2]) sphere(r=(ballDiam/2));
}
// Tray hole
module trayHole(){
    union(){
        // Need to find a better way to do this
        trayMainDiamExtruder(0);
        trayMainDiamExtruder(1);
        trayMainDiamExtruder(2);
        trayMainDiamExtruder(3);
        trayMainDiamExtruder(4);
        translate([(trayX/2)/1.1,6,trayZ/2]) rotate([0,90,0]) cylinder(r=(traySmallDiam/2),h=trayX+2,center=true);
    }
}
module trayCurve(){

    *translate([0,0,-1]) cylinder(r=trayCurve,h=trayZ+2);
    *translate([trayX,0,-1]) cylinder(r=trayCurve,h=trayZ+2);
}
module trayBox(){ 
    translate([(trayX - boxX + boxRadius)/2,-4,1])  cubeRound([boxX,boxY+5,boxZ],boxRadius,false,20); 
}


module traySideExtrude(){
    translate([-4,3,trayZ/2]) cubeRound([10,12,traySmallDiam],2,true,8);
    translate([2,-2,trayZ/2]) cubeRound([8,5,traySmallDiam],2,true,8);
}
module ball(l){
    translate([0,0.2,(ballDiam/2)]) sphere(r=ballDiam/2);
    translate([0,0.2,-l]) cylinder(r=4.7/2,h=l+ballDiam/2);
    // Support for adhesion
    translate([0,-(ballDiam/2)+0.2,ballDiam/2]) rotate([90,0,0]) cylinder(h = .2, r=ballDiam/2);
}
module defaultTray(armL){
    difference(){
        difference(){
            difference(){
                union(){
                    trayBox(); 
                    difference(){
                        //cube([trayX,trayY,trayZ]);  
                        translate([0,0,1]) cubeRound([trayX,trayY,trayZ],1,false,20); 
                        //trayCurve();
                    }
                }
                // Side extrude
                union(){
                    traySideExtrude();
                    mirror([1,0,0]) translate([-13.8,0,0]) traySideExtrude();
                }
            }
            trayHole();
        }
    }
    translate([(trayX/2)-.5,-armL-boxY,trayZ/2+1.32]) rotate([90,0,0]) ball(armL);
}



defaultTray(armLength);



*translate([0,26,-1]) tray(armLength);
//trayHole();

//!traySideExtrude();

*translate([15,-22,0]) rotate([0,0,90]) cube([32.7,15.44,10.26],center=false);







