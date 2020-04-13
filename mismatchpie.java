/******
*	This program takes as input an alignment in fasta format and a consensus.  It reports the 
* 	variants by number of mismatches and indels
*/

import java.io.*;
import java.util.*;

public class mismatchpie
{
	public mismatchpie(String file, String cons)
	{	
		int indel = 0;
		int zero = 0;
		int one = 0;
		int two = 0;
		int three = 0;
		int threeplus = 0;
		
		try
		{
			BufferedReader in = new BufferedReader(new FileReader(file)); //read the alignment
					
			
			String query = in.readLine();
			

			while (query != null)
			{				
				//String query = in.readLine(); //query sequence
											
				
				int mut = 0;
				
				for (int i = 0; i< query.length(); i++) //start at the first position in alignment
				{
					if (cons.charAt(i) == query.charAt(i))
						;
					else if (cons.charAt(i) == '-' || cons.charAt(i) == '-')
					{
						mut = -50000;
						break;
					}
					else
						mut++;
				}
				
				
				if (mut < 0)
					indel++;
				else if (mut == 0)
					zero++;
				else if (mut == 1)
					one++;
				else if (mut == 2)
					two++;
				else if (mut == 3)
					three++;
				else
					threeplus++;
				
				mut = 0;
					
				query = in.readLine();	//read the next name
			}
		
			in.close();
		}
		catch (Exception e)
		{
			System.out.println(e+"oh no");
			e.printStackTrace();
		}
		
		System.out.println("0 mut" + "\t" + zero);
		System.out.println("Indels" + "\t" + indel);
		System.out.println("One mut" + "\t" + one);
		System.out.println("Two mut" + "\t" + two);
		System.out.println("Three mut" + "\t" + three);
		System.out.println("> Three mut" + "\t" + threeplus);

	}
	
	public static void main (String[] args)
	{
		if (args.length != 2)
		{
			System.out.println("Usage is java mismatchpie <fasta alignment> <consensus to match against as string>");
		}
		else
		{
			new mismatchpie(args[0], args[1]);
		}
	}
}