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

ballDiam = 10.2;
armDiam = 4.7;
armLength = 8;
trayMainDiam = 8.4;
traySmallDiam = 4.3;

trayX = 15.8;
trayY = 11;
trayZ = 7.5;
trayRad = 5;
trayCurve = 3.4;


boxX = 8;
boxY = 4;
boxZ = trayZ;
boxRadius = 1;

$fn=50;

module trayMainDiamExtruder(delta){
    translate([trayX/2,8+delta,trayZ/2]) sphere(r=ballDiam/2);
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
        translate([trayX/2,8,trayZ/2]) rotate([0,90,0]) cylinder(r=traySmallDiam/2,h=trayX+2,center=true);
    }
}
module trayCurve(){

    *translate([0,0,-1]) cylinder(r=trayCurve,h=trayZ+2);
    *translate([trayX,0,-1]) cylinder(r=trayCurve,h=trayZ+2);
}
module trayBox(){

    translate([(trayX - boxX + boxRadius)/2,-4,0]) minkowski(){
        cube([boxX-boxRadius,boxY,boxZ-boxRadius]);
        cylinder(r=boxRadius,h=1);
    }  
}

module traySideExtrudeOld(){
            
    minkowski(){
        hull(){
            translate([-1,5,trayZ/2]){
                cube([1,7,4],center=true);
                translate([0,2.5,0]) rotate([0,90,0]) cylinder(r=2,h=1,center=true);
            }
            translate([2,-2,trayZ/2]) cube([7,1,4],center=true);
            //#translate([-5,8,trayZ/2]) cube([1,7,trayZ/2],center=true);
        }
        rotate([90,0,90]) cylinder(r=1,h=1);
    }    

}



module traySideExtrude(){
    
    translate([2,0,0]) rotate([90,0,0]) cubeRound([50,20,50],8,true,20);
   
   
}

module tray(){
    difference(){
        difference(){
            difference(){
                hull(){
                    trayBox(); 
                    difference(){
                        cube([trayX,trayY,trayZ]);   
                        trayCurve();
                    }
                }
                // Side extrude
                union(){
                    traySideExtrude();
                    mirror([1,0,0]) translate([-16,0,0]) traySideExtrude();
                }
            }
            trayHole();
        }
    }
}

module ball(l){
    //translate([trayX/2,armLength,trayZ/2])
    translate([0,0,ballDiam/2]) sphere(r=ballDiam/2);
    translate([0,0,-l]) cylinder(r=4.7/2,h=l+ballDiam/2);
}

tray();
translate([trayX/2,-armLength-boxY,trayZ/2+1.32]) rotate([90,0,0]) ball(armLength);
trayHole();

//!traySideExtrude();




