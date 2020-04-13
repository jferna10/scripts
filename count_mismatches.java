/******
*	This program takes as input an axtx file and a coordinate range.  The coordinates are in the target.  
*	The nucleotides returned are the mapped nucleotides (including gaps) in the matches.  Output is written to a file
*/

import java.io.*;
import java.util.*;

public class count_mismatches
{
	public count_mismatches(String axt_file, int start, int end, String TEname)
	{
		StringTokenizer tk1 = new StringTokenizer(axt_file, ".");
		String noext = tk1.nextToken();
			
		String outfile = "mismatches" +start+"-"+end + noext + ".bedGraph"; //output file name
		
		try
		{
			BufferedReader axt = new BufferedReader(new FileReader(axt_file)); //read the axtx
			
			FileWriter matches = new FileWriter(new File(outfile));		//write the matches
		
			
			String nline = axt.readLine();
			System.out.println(nline);
			int[] mismatches = new int[end-start];
			for (int i = 0; i < mismatches.length; i++)
					mismatches[i] = 0; //initialize to 0
			
			while (nline != null)
			{
				StringTokenizer ntk = new StringTokenizer(nline, " "); //cut up the line by tabs
				
				
				ntk.nextToken();
				ntk.nextToken();
			
				int tstart = Integer.valueOf(ntk.nextToken()); //start on consensus
				int tend = Integer.valueOf(ntk.nextToken()); //end on consensus
				String name =ntk.nextToken(); //name of query
				int qstart = Integer.valueOf(ntk.nextToken()); //start on query
				int qend = Integer.valueOf(ntk.nextToken()); //end on query
				
				
				
				
				String cons = axt.readLine();  //cons aligned
				
				String query = axt.readLine(); //query aligned
											
				if ((tstart < start) && (tend > end))  //if the start and end lie within the mapping
				{
					
					
					int j = 0; //the number of gaps
					int sstart = start-tstart; //string start coord
					
					for (int i = sstart; (i-sstart) < mismatches.length; i++) //start at the first position in alignment
					{
						if (cons.charAt(i+j) == '-')
						{
							mismatches[i-sstart]++;
							j++;
							while (cons.charAt(i+j) == '-') //traverse the gap
							{
								j++;
							}
							i++;
						}
						
						if ((i-sstart) < mismatches.length && cons.charAt(i+j) == query.charAt(i+j))
						{
							mismatches[i-sstart]++;
						}
						
					}

				}	
					
				nline = axt.readLine();	
				nline = axt.readLine();
			}

			matches.write("track type=bedGraph name=\""+ noext+"-"+TEname+ "\" description=\"Track description here \" visibility=full color=200,100,0 altColor=0,100,200 priority=20" + "\n"); //write the bedgraph

			for (int i = 0; i < mismatches.length; i++)
				matches.write(TEname+ "\t" + (i+start) +"\t" + (i+start+1) +"\t" +mismatches[i]+"\n"); //write the bedgraph
			
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
		if (args.length != 4)
		{
			System.out.println("Usage is java extract_aligned <axtx alignment> <nucleotide start> <nucleotide stop> <TE name>");
		}
		else
		{
			new count_mismatches(args[0], Integer.valueOf(args[1]), Integer.valueOf(args[2]), args[3]);
		}
	}
}