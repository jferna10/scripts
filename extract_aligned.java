/******
*	This program takes as input a axtx file and a coordinate range.  The coordinates are in the target.  
*	The nucleotides returned are the mapped nucleotides (including gaps) in the matches.  Output is written to a file
*/

import java.io.*;
import java.util.*;

public class extract_aligned
{
	public extract_aligned(String axt_file, int start, int end)
	{
		StringTokenizer tk1 = new StringTokenizer(axt_file, ".");
		String noext = tk1.nextToken();
			
		String outfile = "matches" +start+"-"+end + noext + ".fa"; //output file name
		
		try
		{
			BufferedReader axt = new BufferedReader(new FileReader(axt_file)); //read the axtx
			
			FileWriter matches = new FileWriter(new File(outfile));		//write the matches
		
			
			String nline = axt.readLine();
			System.out.println(nline);
			
			while (nline != null)
			{
				StringTokenizer ntk = new StringTokenizer(nline, " "); //cut up the line by tabs
				
				
				ntk.nextToken();
				ntk.nextToken();
			
				int tstart = Integer.valueOf(ntk.nextToken()); //start on query
				int tend = Integer.valueOf(ntk.nextToken()); //end on query
				String name =ntk.nextToken(); //name of query
				int qstart = Integer.valueOf(ntk.nextToken()); //start on consensus
				int qend = Integer.valueOf(ntk.nextToken()); //end on consensus
				

				String cons = axt.readLine();  //cons aligned
				
				String query = axt.readLine(); //query aligned
											
				if ((tstart < start) && (tend > end))  //if the start and end lie within the mapping
				{
					matches.write(">"+name + "\n");					//add a bracket for fasta
					int gaps = 0;
					int pad = -1;
					int j = end-tstart;
					
					for (int i = 0; i < j && i < cons.length(); i++) //have to extend the end if the consensus has a gap 
					{
						if (cons.charAt(i) == '-')
							j++;
					}
					
					
					matches.write(query.substring(start-tstart, j) +"\n"); //write the substring
				}	
					
				nline = axt.readLine();	
				nline = axt.readLine();
			}
			
			axt.close();
			matches.close();
		}
		catch (Exception e)
		{
			System.out.println(e+"oh no");
			e.printStackTrace();
		}

	}
	
	public static void main (String[] args)
	{
		if (args.length != 3)
		{
			System.out.println("Usage is java extract_aligned <axtx alignment> <nucleotide start> <nucleotide stop>");
		}
		else
		{
			new extract_aligned(args[0], Integer.valueOf(args[1]), Integer.valueOf(args[2]));
		}
	}
}