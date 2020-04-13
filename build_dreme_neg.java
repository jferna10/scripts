/******
*	This program takes as input one fasta file.  These sequences represent TE instances that are  
*	are 'unbound' (no ChIP seq summits) by a KZNF which binds many TE instances of the same class.
* 	The point is to take these TE instances and chop them into 140-mers as this is what is required to
*	match the positive dreme dataset. This will inflate the significane as portions of the TE that don't
*	align to the binding site are chopped up and included in the analysis (i.e. E-value meaning is unclear). 
*	TEs less than 140 are tossed. The result is a negative input file for dreme. 
*
****/

import java.io.*;
import java.util.*;

public class build_dreme_neg
{
	public build_dreme_neg(String neg)
	{
		try
		{
			BufferedReader negfile = new BufferedReader(new FileReader(neg)); //read the neg sequences
			FileWriter dneg = new FileWriter(new File("chop-"+ neg));		//write the chopped sequences
			
			String nline = negfile.readLine();
			String name;
			//System.out.println(nline);
			while (nline != null)
			{
				name = nline;				//store the name
				nline = negfile.readLine(); //get the seq
				

				if(nline.length() > 140) //only want things greater than 200, otherwise too short!
				{
					for (int i = 0; i < nline.length()/140; i++) //how many 140-mers in TE
					{
						if ((i*140 + 140) > nline.length()) //if at end
						{
							dneg.write(name+"_"+ i + "\n");  //write name
							dneg.write(nline.substring(nline.length()-140, nline.length()) + "\n");  //write 140-merseq
						}
						else
						{
							dneg.write(name+"_"+ i + "\n");  //write name
							dneg.write(nline.substring(i*140, i*140+140) + "\n");  //write 140-mer seq
						}
					}
				}
				
				nline = negfile.readLine();					//get the next seq 							
			}
			
			negfile.close();
			dneg.close();
		}
		catch (Exception e)
		{
			System.out.println(e+"oh no");
		}
	}
	
	public static void main (String[] args)
	{
		if (args.length != 1)
		{
			System.out.println("Usage is java build_dreme_neg <unbound fa to chop>");
		}
		else
		{
			new build_dreme_neg(args[0]);
		}
	}
}