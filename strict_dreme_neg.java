/******blob
*	This program takes as input two psl files.  One is chip-seq data (bound) subsetted to one TE class mapped to a consensus.  
*	The other is chopped up TE instances of the same type that are 'unbound' (no ChIP seq summits)
* 	The point is to take the chopped up TE and find a 140-mer that overlaps when aligned.  This is a strict negative, the
*	same region in an unbound element for dreme to tease apart motifs from. 
*
****/
import java.io.*;
import java.util.*;

public class strict_dreme_neg
{
	public strict_dreme_neg(String pos, String neg)
	{
		StringTokenizer tk1 = new StringTokenizer(neg, ".");
		String noext = tk1.nextToken();
			
		String outfile = "strict_map_"+ noext + ".fa"; //output file name
		
		try
		{
			BufferedReader negfile = new BufferedReader(new FileReader(neg)); //read the neg sequences
			
			FileWriter dneg = new FileWriter(new File(outfile));		//write the chopped sequences
		
			String nline = negfile.readLine();
			
			for(int i=0; nline != null &&  i < 5; i++)  //clear the psl header
				nline = negfile.readLine();
				
			
			String p_name="";									//will hold fasta seq name
			int n_elements= 0;									//counts number of elements to put in neg set
			
			int pt_start;									//coordinates on target consensus
			int pt_end;
			
			int nt_start;
			int nt_end;
			String n_name="";
			
			while (nline != null)
			{
				StringTokenizer ntk = new StringTokenizer(nline, "\t"); //cut up the line by tabs
				for (int i=0; i<9;i++) //first 8 fields we don't care about
					ntk.nextToken();
			
				n_name = ntk.nextToken(); //10th field has chrom coordinates
				
				for (int i=0; i<5;i++) //next 8 fields we don't care about
					ntk.nextToken();   	
				
				nt_start = Integer.valueOf(ntk.nextToken());//target start in consensus
				nt_end = Integer.valueOf(ntk.nextToken());
				
				for (int i=0; i<4;i++) //next 4 fields we don't care about
						ntk.nextToken();  
					
				String seq = ntk.nextToken(); //seq is 22nd field
				
				//System.out.println(n_name +" "+nt_start + " " +nt_end);
				
				BufferedReader posfile = new BufferedReader(new FileReader(pos)); //read the positive files
				
				String pline = posfile.readLine();				//read the first line of neg file
				
				for(int i=0; pline != null && i < 5; i++)  //clear the psl header
					pline = posfile.readLine();
				
				boolean found = false;
				
				while ((pline != null) && !found)
				{
					//System.out.println(n_name);
					StringTokenizer tk = new StringTokenizer(pline, "\t"); //cut up the line by tabs
					
					for (int i=0; i<9;i++) //first 8 fields we don't care about
						tk.nextToken();
					
					p_name=tk.nextToken(); //10th field has chrom coordinates
					
					
					for (int i=0; i<5;i++) //next 5 fields we don't care about
						tk.nextToken();   	
					
					pt_start = Integer.valueOf(tk.nextToken());//target start in consensus is 16th 
					pt_end = Integer.valueOf(tk.nextToken()); //target end is 17th
					
					
					
					if (pt_start > pt_end)  //flip the start and stop in the case of neg strand
					{
						int temp = pt_start;
						pt_start = pt_end;
						pt_end = temp;
					}
					
					//System.out.println(p_name +" "+pt_start + " " +pt_end);
				
										
					if ((pt_start < nt_start  && nt_start < pt_end) || (pt_start < nt_end  && nt_end < pt_end)) //if the negative 140mer lies within the positive fragment use it as part of the background
					{
						//System.out.println(n_name);
						dneg.write(">"+n_name + "\n");					//add a bracket for fasta
						dneg.write(seq.substring(0, seq.length()-1) +"\n"); //cut out the blat comma
						n_elements++;
						found = true; //if the negative peak overlaps any of the positive peaks we'll add it and not continue to compare 
					}	
					
					pline = posfile.readLine();					//get the next seq 

				}
				posfile.close();
				nline = negfile.readLine();										
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
		if (args.length != 2)
		{
			System.out.println("Usage is java strict_dreme_neg <psl alignment bound> < psl alignment unbound>");
		}
		else
		{
			new strict_dreme_neg(args[0], args[1]);
		}
	}
}