use <utils/build_plate.scad>
include <write/Write.scad>
include <bezier.scad>
use <bezier.scad>
use <Write.scad>

$fn=50*1;

// Modified version of the Customizable Cuffs & Collars
// Author: fastkite
// Copyright: 2013

//Select the diameter of the inside of the bracet in mm.  This should be at least as wide as the thing you are cuffing. Examples of wrist sizes to get you started:  62-XS, 65-S, 70-M, 75-L, 80-XL. Currently Selected:
Cuff_Size = 70; // [10:200]

// Width of the cuffs in mm. Currently Selected:
Cuff_Width = 30; // [15:80]

// Thickness of the cuffs in mm. Currently selected:
//Cuff_Thickness = Cuff_Width/4;  //=5; //[5:40]

//Personalize your cuffs with an inscription, or various other options
Accent_Style = 2; // [0:Emboss Inscription,1:Engrave Inscription,2:Studs, 3:Holes, 4:Plain, 5:Hearts]

Studs_Style = 3; // [1:Stud,2:Spikes,3:Pyramid]

//Text (or accent) height should be less than the top surface width. Currently Selected:
font_height = 15; // [7:30]
font_bold = 0.5; // [0,0.5,1,1.5,2,2.5,3:3]

//enter your custom inscription
Front_Inscription = "My";

//enter your custom inscription
Back_Inscription = "Pet";

//select the font of your choice
font = "write/knewave.dxf"; //["write/Letters.dxf":Basic,"write/orbitron.dxf":Futuristic,"write/BlackRose.dxf":Fancy,"write/braille.dxf":Braille,"write/knewave.dxf":Smooth]


// font depth can be adjusted, if embossing a smaller number is best. If you are engraving try out 25 to cut the letters out entierly for an interesting effect
font_depth = 3; // [0.5,1,2,3,5,8,25:25 - Cutout]


//Would you like a bracket to attach a string or rope?
Attachment_Bracket = 2; //[0:None,1:One Side,2:Both Sides]

//Adjust the size of the attachment bracket
Attachment_Style = 10; //[0:None,5:Small,10:Medium,20:Thick]

//Adjust the size of the hole in the attachment braket to accomodate different size rope or string
Attachment_Hole_Size = 7; // [5:Small,7:Medium,10:Large]



//The head on the locking pin can make it easier to remove the cuffs without the key.  If you do not wish to put a head on the pin making it more difficult to remove the cuffs select No head.
Locking_Pin_Head_Size=3; //[0:No head, 1:Small, 3:Medium, 5:Larger]

//Square locking pin heads are easier to wiggle out without using the key
Locking_Pin_Head_Shape=1*1; // //[0:Round,1:Square]



//Which parts would you like to print.
Print_Parts = 1; // [1:Everything,2:Cuffs only,5:Lock Pin only,6:Key only]



//for display only, doesn't contribute to final object
build_plate_selector = 0; //[0:Replicator 2,1: Replicator,2:Thingomatic,3:Manual]

//when Build Plate Selector is set to "manual" this controls the build plate x dimension
build_plate_manual_x = 120; //[100:400]

//when Build Plate Selector is set to "manual" this controls the build plate y dimension
build_plate_manual_y = 120; //[100:400]

build_plate(build_plate_selector,build_plate_manual_x,build_plate_manual_y);



gDemoSteps = 10; // Subdiviciones del corazon
gDemoHeight = 20;// Ancho del corazon

emboss_or_engrave = Accent_Style;
print=Print_Parts;

inscription1 = Front_Inscription;
inscription2 = Back_Inscription;

cuff_inside_d = Cuff_Size;
cuff_wall = Cuff_Width/4;
cuff_outside_d = cuff_inside_d+cuff_wall*2;
cuff_middle_d = (cuff_outside_d+cuff_inside_d)/2;

cuff_hole_d = cuff_wall/2;
cuff_width = Cuff_Width;

cuff_edge_radius = cuff_wall/3;

hinge_play = 0.75*1;
hinge_hole_d = cuff_wall/2;


fudge = 0.05*1; // used to prevent 0 thinkness issues

hinge_offset = cuff_wall/2+hinge_play;

pin_head_d = hinge_hole_d+5;
pin_head_z = Locking_Pin_Head_Size;
pin_head_square = Locking_Pin_Head_Shape;


key_d = hinge_hole_d*0.9;// make the key smaller to fit in the hole
key_head_d = hinge_hole_d+5;
key_head_z = 5*1;

attachment_hole_d = Attachment_Hole_Size;
attachment_z = Attachment_Style;
attachment_count = Attachment_Bracket;

stud_d = font_height;
stud_deep = font_height/2+cuff_wall/2;


hole_d = font_height;

//		writecylinder(inscription,[0,0,0],cuff_outside_d/2,0,rotate=0,font=font,
	//				t=font_depth,h=font_height);


//make_cuff_side_1 ();
build_on_build_plate();

module DrawHeart() {
	translate([-150, -190, -2]) {
		BezCubicFilletColored( [[150, 150],[150,120],[100,120],[100,150]], [150,150], 
		gDemoSteps, gDemoHeight, [[1,0,0],[1,0,0],[1,1,1],[1,0,0]]);
		
		BezCubicFilletColored( [[100, 150],[100,180],[150,185],[150,210]], [150,150], 
		gDemoSteps, gDemoHeight, [[1,0,0],[1,0,0],[1,1,1],[1,0,0]]);
		
		BezCubicFilletColored( [[150, 210],[150,185],[200,180],[200,150]], [150,150], 
		gDemoSteps, gDemoHeight,  [[1,0,0],[1,0,0],[1,1,1],[1,0,0]]);
		
		BezCubicFilletColored( [[200, 150],[200,120],[150,120],[150,150]], [150,150], 
		gDemoSteps, gDemoHeight,  [[1,0,0],[1,0,0],[1,1,1],[1,0,0]]);
	}
}


module oneHeart(r,p) { 
//r= angulo en el que aparece el corazon
//p= la medida de profundidad en la que penetra

			translate([0,-cuff_middle_d/2,0])
			rotate(r,[1,0,0])	
scale([(Cuff_Width/3)/60,(Cuff_Width/3)/60,(Cuff_Width/2)/60])
			translate([0,2,p])
			DrawHeart();
}


module hearts (side) {
	if (side == 1) {
		rotate(0,[0,0,1])
			oneHeart(90);

		rotate(19,[0,0,1])
			oneHeart(-90,-16);
		rotate(-19,[0,0,1])
			oneHeart(-90,-16);

		rotate(37,[0,0,1])
			oneHeart(90);
		rotate(-37,[0,0,1])
			oneHeart(90);

		rotate(-56,[0,0,1])
			oneHeart(-90,-16);
		rotate(56,[0,0,1])
			oneHeart(-90,-16);

		rotate(74,[0,0,1])
			oneHeart(90);		
		rotate(-74,[0,0,1])
			oneHeart(90);


	} else {

		rotate(180+0,[0,0,1])
			oneHeart(90);

		rotate(180+17,[0,0,1])
			oneHeart(-90,-16);

		rotate(180-17,[0,0,1])
			oneHeart(-90,-16);

		rotate(180+35,[0,0,1])
			oneHeart(90);
		rotate(180+52,[0,0,1])
			oneHeart(-90,-16);

		rotate(180-35,[0,0,1])
			oneHeart(90);
		rotate(180-52,[0,0,1])
			oneHeart(-90,-16);

		if (Attachment_Bracket <= 1) { rotate(180+70,[0,0,1])oneHeart(90); }

		//	oneHeart(90);

		if (Attachment_Bracket == 0) { rotate(180-70,[0,0,1]) oneHeart(90); }
		//	oneHeart(90);

	}

}


module hole() {

	translate([0,cuff_middle_d/2,0])
	rotate(90,[1,0,0])
			cylinder (r=hole_d/2,h=cuff_wall*2,center=true);
			//cylinder (r=hole_d/2,h=cuff_wall,center=true);
			//cube([hole_d/2, hole_d/2, cuff_wall], center = true);
}

module holes() {

		rotate(0,[0,0,1])
			hole();

		rotate(37,[0,0,1])
			hole();

		rotate(-37,[0,0,1])
			hole();

		//rotate(74,[0,0,1])
		//	hole();

		//rotate(-74,[0,0,1])
		//	hole();


		rotate(180+0,[0,0,1])
			hole();

		rotate(180+35,[0,0,1])
			hole();

		rotate(180-35,[0,0,1])
			hole();

		rotate(180+70,[0,0,1])
			hole();

		rotate(180-70,[0,0,1])
			hole();

}

module stud(a) {
	translate([0,-cuff_middle_d/2,a])
		rotate(90,[1,0,0])
			if (Studs_Style == 1) { //Half Sphere
				difference() {
        			resize(newsize=[stud_d/1.5,stud_d/1.5,stud_d]) sphere(r=stud_d);	 
        			translate([0,0,-stud_deep/2]) cube(stud_deep,center = true);
         						}
			} else if (Studs_Style == 2) { //Cone
				cylinder (r1=stud_d/2,r2=0,h=stud_deep);
			
			} else if (Studs_Style == 3) { //pyramid
				//translate([0,0,stud_deep/12])
polyhedron(
  				points=[ [stud_d/2,stud_d/2,0],[stud_d/2,-stud_d/2,0],[-stud_d/2,-stud_d/2,0],[-stud_d/2,stud_d/2,0], // the four points at base
           [0,0,stud_d/2]  ],                                 // the apex point 
  faces=[ [0,1,4],[1,2,4],[2,3,4],[3,0,4],              // each triangle side
              [1,0,3],[2,1,3] ]                         // two triangles for square base
 );
			}//else if (Studs_Style == 4) {
					//translate([0,cuff_middle_d/4,-stud_d/2]) rotate(180,[0,0,0]) resize(newsize=[stud_d/2,stud_d/2,stud_d]) oneHeart();
			//}
}

module studs (side) {
	if (side == 1) {
		rotate(0,[0,0,1])
			stud();

		rotate(18,[0,0,1])
			stud(Cuff_Width/4);
		rotate(-18,[0,0,1])
			stud(Cuff_Width/4);

		rotate(18,[0,0,1])
			stud(-Cuff_Width/4);
		rotate(-18,[0,0,1])
			stud(-Cuff_Width/4);

		rotate(37,[0,0,1])
			stud();
		rotate(-37,[0,0,1])
			stud();

		rotate(55,[0,0,1])
			stud(Cuff_Width/4);

		rotate(-55,[0,0,1])
			stud(Cuff_Width/4);

		rotate(55,[0,0,1])
			stud(-Cuff_Width/4);

		rotate(-55,[0,0,1])
			stud(-Cuff_Width/4);

		rotate(74,[0,0,1])
			stud();

		rotate(-74,[0,0,1])
			stud();


	} else {

		rotate(180+0,[0,0,1])
			stud();

		rotate(180-17,[0,0,1])
			stud(-Cuff_Width/4);
		rotate(180+17,[0,0,1])
			stud(-Cuff_Width/4);
		rotate(180-17,[0,0,1])
			stud(Cuff_Width/4);
		rotate(180+17,[0,0,1])
			stud(Cuff_Width/4);

		rotate(180+35,[0,0,1])
			stud();
		rotate(180-35,[0,0,1])
			stud();

		rotate(180-52,[0,0,1])
			stud(-Cuff_Width/4);
		rotate(180+52,[0,0,1])
			stud(-Cuff_Width/4);
		rotate(180-52,[0,0,1])
			stud(Cuff_Width/4);
		rotate(180+52,[0,0,1])
			stud(Cuff_Width/4);

		rotate(180+70,[0,0,1])
			stud();

		rotate(180-70,[0,0,1])
			stud();

	}

}


module build_on_build_plate() {
	if (print==1 || print == 2) {// print the front cuff
			translate ([+cuff_middle_d/2,0,cuff_width/2]) 
				rotate (5,[0,0,1]) 
				translate ([-cuff_middle_d/2,0,0]) 
					make_cuff_side_1 ();
			translate ([0,0,cuff_width/2]) 
				make_cuff_side_2 ();
			translate ([cuff_middle_d/2,0,0]) 
				hinge_pin();
	}

	if (print==1 || print == 5) // print the front cuff
		translate ([-pin_head_d,0,0]) 
			pin();
	
	if (print==1 || print == 6) // print the front cuff
		translate ([0,-pin_head_d,0]) 
			key();	
}





module attachment_point () {

	attachment_radius = attachment_z/4;

	join_block_size = attachment_hole_d/2+cuff_wall/2+attachment_radius*2;
	
	if (attachment_count==1 || attachment_count==2 ) {

		translate([cuff_middle_d/2+attachment_hole_d/2+cuff_wall/2,attachment_hole_d,0]) 

			difference() {
				union() {
					translate([-join_block_size/2+attachment_radius,0,0])
						rounded_cube([join_block_size,attachment_hole_d*2,attachment_z], attachment_radius);
		
					rounded_cyliner (rad=attachment_hole_d,corner_radius=attachment_radius,height=attachment_z);
				}	

				cylinder(r = attachment_hole_d/2, h = cuff_width+fudge, center = true);
			}
	}

	// add the second bracket
	if (attachment_count==2 ) {

			translate([-(cuff_middle_d/2+attachment_hole_d/2+cuff_wall/2),attachment_hole_d,0]) 

				difference() {
					union() {
						translate([-(-join_block_size/2+attachment_radius),0,0])
							rounded_cube([join_block_size,attachment_hole_d*2,attachment_z], attachment_radius);
			
						rounded_cyliner (rad=attachment_hole_d,corner_radius=attachment_radius,height=attachment_z);
					}	

					cylinder(r = attachment_hole_d/2, h = cuff_width+fudge, center = true);
				}
	}



}

module pin () {

	translate([0,0,(cuff_width+pin_head_z)/2])
		//rounded_cyliner (r=hinge_hole_d/2,corner_radius=hinge_hole_d/6,height=cuff_width+pin_head_z);
		cylinder (r=hinge_hole_d/2,h=cuff_width+pin_head_z,center=true);


	if (pin_head_z > 0) {
		if (pin_head_square==1) {
			translate([0,0,(pin_head_z)/2])
				rounded_cube([pin_head_d,pin_head_d, pin_head_z], pin_head_z/2);
				
		} else {
			translate([0,0,(pin_head_z)/2])
				rounded_cylinder(r = pin_head_d/2, corner_radius=pin_head_z/2, height=pin_head_z);
		}
	}
}

module hinge_pin () {
echo (hinge_hole_d);
	translate([0,0,cuff_width/2])
		cylinder(r=hinge_hole_d/2,h=cuff_width,center=true);


}




module key () {

	

	translate([0,0,(cuff_width+key_head_z)/2])
		cylinder(r=key_d/2,h=cuff_width+key_head_z,center=true);
		//rounded_cyliner (r=key_d/2,corner_radius=key_d/4,height=cuff_width+key_head_z);


	if (key_head_z > 0) {
		translate([0,0,pin_head_z/2])
			rounded_cube([pin_head_d,pin_head_d, pin_head_z], pin_head_z/2,center=true);
			//rounded_cyliner(r = key_head_d/2, corner_radius=key_head_z/4, height=key_head_z);
	}
}

module hinge_hole (side = 1) {

	if (side == 1) {
		cylinder(r = 	hinge_hole_d/2, h = cuff_width+fudge, center = true);
	} else {
		cylinder(r = 	hinge_hole_d/2+hinge_play/2, h = cuff_width+fudge, center = true);

	}

}


module hinge (side =1) {
// create a hindge in the middle, something else will move it into position

	segment = cuff_width/3-hinge_play;

	length_of_filler = cuff_wall/2+hinge_offset+cuff_edge_radius;

	if (side == 1 ) {
		translate([0, 0, cuff_width/3+hinge_play/2])
			//rounded_cube ([cuff_wall,cuff_wall,segment],cuff_edge_radius);
			rounded_cyliner (rad=cuff_wall/2,corner_radius=cuff_edge_radius,height=segment);

		translate([0, 0, -cuff_width/3-hinge_play/2])
			//rounded_cube ([cuff_wall,cuff_wall,segment],cuff_edge_radius);
			rounded_cyliner (rad=cuff_wall/2,corner_radius=cuff_edge_radius,height=segment);

		*translate([0, -hinge_offset/2-cuff_edge_radius, cuff_width/3+hinge_play/2])
			rounded_cube ([cuff_wall,hinge_offset+cuff_edge_radius*2,segment],cuff_edge_radius);
			//rounded_cyliner (rad=cuff_wall/2,corner_radius=cuff_edge_radius,height=segment);

		*translate([0, -hinge_offset/2-cuff_edge_radius, -cuff_width/3-hinge_play/2])
			rounded_cube ([cuff_wall,hinge_offset+cuff_edge_radius*2,segment],cuff_edge_radius);
			//rounded_cyliner (rad=cuff_wall/2,corner_radius=cuff_edge_radius,height=segment);


		translate([0, -length_of_filler/2+cuff_edge_radius, -cuff_width/3-hinge_play/2])
			rounded_cube ([cuff_wall,length_of_filler,segment],cuff_edge_radius);

		translate([0, -length_of_filler/2+cuff_edge_radius, cuff_width/3+hinge_play/2])
			rounded_cube ([cuff_wall,length_of_filler,segment],cuff_edge_radius);



	} else {

		translate([0, 0, 0])
			//rounded_cube ([cuff_wall,cuff_wall,cuff_width/3],cuff_edge_radius);
			rounded_cyliner (rad=cuff_wall/2,corner_radius=cuff_edge_radius,height=cuff_width/3);
	
/*
		translate([0, hinge_offset/2+cuff_edge_radius, 0])
			rounded_cube ([cuff_wall,hinge_offset+cuff_edge_radius*2,cuff_width/3],cuff_edge_radius);
*/

		translate([0, length_of_filler/2-cuff_edge_radius, 0])
			rounded_cube ([cuff_wall,length_of_filler,cuff_width/3],cuff_edge_radius);





	}
}


module rounded_cyliner (rad,corner_radius,height) {


	cylinder(r = rad, h = height, center = true);

/*

	// there some issue with this code that it works in OpenSCad but it won't convert to STL.  Not sure what the issue is.
		rotate_extrude(convexity = 20)	
			translate([rad-corner_radius, height/2-corner_radius, 0])
				circle(r = corner_radius);

		rotate_extrude(convexity = 20)
			translate([rad-corner_radius, -height/2+corner_radius, 0])
				circle(r = corner_radius);

		cylinder(r = 	rad-corner_radius, h = height, center = true);

		*rotate_extrude(convexity = 10)
			translate([0, 0, 0])
				square ([rad*2-corner_radius*2,height],center = true);	


		cylinder(r = 	rad, h = height-corner_radius*2, center = true);
		*rotate_extrude(convexity = 10)
			translate([0, 0, 0])
				square ([rad*2,height-corner_radius*2],center = true);	

		*/
}






module rounded_cube(size, radius)
// Modified version of the function available in this library
// roundedBox([width, height, depth], float radius, bool sidesonly);
// Library: boxes.scad
// Version: 1.0
// Author: Marius Kintel
// Copyright: 2010
// License: BSD

{
  rot = [ [0,0,0], [90,0,90], [90,90,0] ];

    cube([size[0], size[1]-radius*2, size[2]-radius*2], center=true);
    cube([size[0]-radius*2, size[1], size[2]-radius*2], center=true);
    cube([size[0]-radius*2, size[1]-radius*2, size[2]], center=true);

    for (axis = [0:2]) {
      for (x = [radius-size[axis]/2, -radius+size[axis]/2],
             y = [radius-size[(axis+1)%3]/2, -radius+size[(axis+1)%3]/2]) {
        rotate(rot[axis])
          translate([x,y,0])
          cylinder(h=size[(axis+2)%3]-2*radius, r=radius, center=true);
      }
    }
    for (x = [radius-size[0]/2, -radius+size[0]/2],
           y = [radius-size[1]/2, -radius+size[1]/2],
           z = [radius-size[2]/2, -radius+size[2]/2]) {
      translate([x,y,z]) sphere(radius);
    }
  
}


module make_cuff_side_1 () {
		

	translate([0, -hinge_offset, 0]) {
		difference() {
			full_round_with_text ();
			mask_half (side=1);
			
			if (emboss_or_engrave==3)
				holes();
		}

		if (emboss_or_engrave==0) {
			translate ([0,0,font_height/8]) {
				writecylinder(inscription1,[0,0,0],cuff_outside_d/2,0,rotate=0,font=font,
					t=font_depth,h=font_height,bold=font_bold,center=true);
			}
		}


		if (emboss_or_engrave==2) //
			studs(side=1);

		if (emboss_or_engrave==5) //Si la opcion es 5, llama a corazones
			hearts(side=1);



		translate([cuff_middle_d/2, -cuff_edge_radius, 0])
			rounded_cube([cuff_wall,cuff_edge_radius*2,cuff_width], radius=cuff_edge_radius);
		translate([-cuff_middle_d/2, -cuff_edge_radius, 0])
			rounded_cube([cuff_wall,cuff_edge_radius*2,cuff_width], radius=cuff_edge_radius);

	}

// create side 1 hinge
	translate([cuff_middle_d/2, 0, 0])
	difference() {
		hinge (side = 1);
		hinge_hole(side = 1);



	}
	translate([-cuff_middle_d/2, 0, 0])
		difference() {
			hinge (side = 1);
			hinge_hole(side = 1);
		}


}



module make_cuff_side_2 () {
	translate([0, +hinge_offset, 0]) {
		difference() {
			full_round_with_text();
			mask_half (side=2);
			if (emboss_or_engrave==3)
				holes();
		}

		if (emboss_or_engrave==0) { // emboss
			translate ([0,0,font_height/8]) {

				rotate (a=180,v=[0,0,1])
					writecylinder(inscription2,[0,0,0],cuff_outside_d/2,0,rotate=0,font=font,
						t=font_depth,h=font_height,bold=font_bold,center=true);
			}
		}

		if (emboss_or_engrave==2) //
			studs(side=2);

		if (emboss_or_engrave==5) //Si la opcion es 5, llama a corazones
			hearts(side=2);




		translate([cuff_middle_d/2, cuff_edge_radius, 0])
			rounded_cube([cuff_wall,cuff_edge_radius*2,cuff_width], radius=cuff_edge_radius);

		translate([-cuff_middle_d/2, cuff_edge_radius, 0])
			rounded_cube([cuff_wall,cuff_edge_radius*2,cuff_width], radius=cuff_edge_radius);

// create attachement point
			attachment_point ();
		

	}
		


// create side 2 hinge
	translate([cuff_middle_d/2, 0, 0])
	difference() {
		hinge (side = 2);
		hinge_hole(side = 2);
	}




	translate([-cuff_middle_d/2, 0, 0])
	difference() {
		hinge (side = 2);
		hinge_hole(side = 2);
	}



}


module mask_half (side=1) {
	if (side == 1) {
		translate([0, (cuff_outside_d/2+fudge+cuff_edge_radius*2)/2 - cuff_edge_radius, 0])
			cube([cuff_outside_d+fudge,
					cuff_outside_d/2+fudge+cuff_edge_radius*2,
					cuff_width+fudge], center=true);
	} else {

		translate([0, -((cuff_outside_d/2+fudge+cuff_edge_radius*2)/2 - cuff_edge_radius), 0])
			cube([cuff_outside_d+fudge,
					cuff_outside_d/2+fudge+cuff_edge_radius*2,
					cuff_width+fudge], center=true);

	}

}

module full_round_cuff () {

	cuff_radius_x_offset = cuff_wall/2-cuff_edge_radius;
	cuff_radius_y_offset = cuff_width/2-cuff_edge_radius;


		rotate_extrude(convexity = 10, $fn = 50)
			translate([cuff_middle_d/2+cuff_radius_x_offset, cuff_radius_y_offset, 0])
				circle(r = cuff_edge_radius, $fn = 50);
		rotate_extrude(convexity = 10, $fn = 50)
			translate([cuff_middle_d/2-cuff_radius_x_offset, cuff_radius_y_offset, 0])
				circle(r = cuff_edge_radius, $fn = 50);

		rotate_extrude(convexity = 10, $fn = 50)
			translate([cuff_middle_d/2+cuff_radius_x_offset, -cuff_radius_y_offset, 0])
				circle(r = cuff_edge_radius, $fn = 50);

		rotate_extrude(convexity = 10, $fn = 50)
			translate([cuff_middle_d/2-cuff_radius_x_offset, -cuff_radius_y_offset, 0])
				circle(r = cuff_edge_radius, $fn = 50);
		rotate_extrude(convexity = 10, $fn = 50)
			translate([cuff_middle_d/2, 0, 0])
				square ([cuff_wall,cuff_width-cuff_edge_radius*2],center = true);				

		rotate_extrude(convexity = 10, $fn = 50)
			translate([cuff_middle_d/2, 0, 0])
				square ([cuff_wall-cuff_edge_radius*2,cuff_width],center = true);	

		
}



module full_round_with_text() {
	difference() {
		full_round_cuff();

		// engraving
		if (emboss_or_engrave==1) {
			translate ([0,0,font_height/8]) {
				writecylinder(inscription1,[0,0,0],cuff_outside_d/2,0,rotate=0,font=font,
					t=font_depth*2,h=font_height,bold=font_bold,center=true);

				rotate (a=180,v=[0,0,1])
					writecylinder(inscription2,[0,0,0],cuff_outside_d/2,0,rotate=0,font=font,
						t=font_depth*2,h=font_height,bold=font_bold,center=true);
			}
		}
	}


//embossing
		*if (emboss_or_engrave==0) {
			translate ([0,0,font_height/8]) {
				writecylinder(inscription1,[0,0,0],cuff_outside_d/2,0,rotate=0,font=font,
					t=font_depth,h=font_height,bold=font_bold,center=true);

				rotate (a=180,v=[0,0,1])
					writecylinder(inscription2,[0,0,0],cuff_outside_d/2,0,rotate=0,font=font,
						t=font_depth,h=font_height,bold=font_bold,center=true);
			}
		}


}

