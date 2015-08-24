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
kneeMainDiam = 8.4;
kneeSmallDiam = 4.3;

// knee
kneeX = 15.8;
kneeY = 11;
kneeZ = 7.5;
kneeRad = 5;
kneeCurve = 3.4;

// Box
boxX = 8;
boxY = 4;
boxZ = kneeZ;
boxRadius = 1;
sideExtrudeHeight=4;


$fn=50;

module kneeMainDiamExtruder(delta){
    //translate([7,6+delta,kneeZ/2]) sphere(r=(ballDiam/2));
    translate([7,5+delta,kneeZ/2]) sphere(r=(ballDiam/2)+0.1);
}
// knee hole
module kneeHole(){
    union(){
        // Need to find a better way to do this
        kneeMainDiamExtruder(0);
        kneeMainDiamExtruder(1);
        kneeMainDiamExtruder(2);
        //kneeMainDiamExtruder(3);
        //kneeMainDiamExtruder(4);
        translate([(kneeX/2)/1.1,6,kneeZ/2]) rotate([0,90,0]) cylinder(r=(kneeSmallDiam/2),h=kneeX+2,center=true);
    }
}

module kneeBox(){ 
    translate([(kneeX - boxX)/2,-4,1])  cubeRound([boxX,boxY+5,boxZ],boxRadius,false,20); 
}

module kneeSideExtrude(){
    translate([-4,3,kneeZ/2]) cubeRound([10,12,kneeSmallDiam],2,true,8);
    *#translate([2,-2,kneeZ/2]) cubeRound([8,2,kneeSmallDiam],2,true,8);
}
module ball(l,s){
    translate([0,0.2,(ballDiam/2)+.1]) sphere(r=ballDiam/2);
    // Support for adhesion
    if(s){
        translate([0,0,.1]) rotate([0,0,0]) cylinder(h = .2, r=ballDiam/2,center=true);
    }
}

module arm(l){
    // -2 à enveler
    translate([0,0,0]) rotate([90,0,0]) cylinder(r=4.7/2,h=l+ballDiam/2,$fn=6);

}   

module knee(){
    difference(){
        difference(){
            difference(){
                union(){
                    kneeBox(); 
                    translate([0,0,1]) cubeRound([kneeX,kneeY,kneeZ],1,false,20); 
                }
                // Side extrude
                union(){
                    kneeSideExtrude();
                    mirror([1,0,0]) translate([-13.8,0,0]) kneeSideExtrude();
                }
            }
            kneeHole();
        }
    }  
}

module default(armL){
    knee();
    translate([(kneeX/2)-boxRadius,-2,5]) arm(armL);
    *translate([(kneeX/2)-.5,-armL-boxY,kneeZ/2+1.32])  ball(armL);
    translate([(kneeX/2)-boxRadius,-armL-10,0]) ball(armL,true);
    //ball(armL);
}

module kneeknee(armL){
    knee();
    translate([(kneeX/2)-boxRadius,0,3.5]) arm(armL);
    mirror([0,1,0]) translate([0,armL+10,0]) knee();
}

module ballball(armL){
    ball(armL,true);
    translate([0,-2,5]) arm(armL);
    mirror([0,1,0]) translate([0,armL+10,0]) ball(armL,true);
}

module crossball(armL){
    ballball(armL);
    translate([-(armL/2)-5,(-armL/2)-5,0]) rotate([0,0,90]) #ballball(armL);
}

module hip(armL){
    //armL = 15;
    knee();
    translate([(kneeX/2)-boxRadius,0,3.5]) arm(armL);
    mirror([0,1,0]) translate([0,armL+10,0]) knee();
    
    translate([11.8,-(armL+ballDiam)/2,5.3]) rotate([270,0,90]) union(){
        translate([0,0,0]) ball(armL);
        translate([0,-2,5.2]) arm(armL);
        translate([0,-armL-10,0]) ball(armL);
    }
}

// Demo
module demoDefault(){
    for (i = [1:4]) 
    {
        translate([i*20,0]) default(i*20);
    }
}

module demoKneelknee(){
    for (i = [1:4]) 
    {
        translate([i*20,0]) kneeknee(i*20);
    }
}
module demoBallball(){
    for (i = [1:4]) 
    {
        translate([i*20,0]) ballball(i*20);
    }
}

module demoCrossball(){
    for (i = [1:4]) 
    {
        translate([i*60,i*-15,0]) crossball(i*20);
    }
}

module demoHip(){
    for (i = [1:4]) 
    {
        translate([i*60,0,0]) hip(i*20);
    }
}

module demoSet(armL){
    translate([0,0,0]) default(armL);
    translate([25,0,0]) kneeknee(armL);
    translate([50,0,0]) ballball(armL);
    translate([65,0,0]) hip(armL);
    translate([90+armL,0,0]) crossball(armL);
}    

//demoDefault();
//demoKneelknee();
//demoBallball();
//demoCrossball();
//demoHip();

//demoSet(20);

//default(25);

ballball(30);