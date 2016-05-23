import java.lang.Runnable;
import java.util.ArrayList;
import java.lang.Double;
public class FastFilter implements Runnable
{
	
	private ArrayList<Double> b;
	private ArrayList<Double> a;

	private ArrayList<Double> data;
	private int ext;
	private Boolean zeroPhase;


	public void run()
	{
		
	}
	//b is denominator coefficients
	//a is nominator coefficients
	//data is signal
	//ext is the extension
	//if zeroPhase is true, implement zero-phase filter 
	public FastFilter(ArrayList<Double> b, ArrayList<Double> a, ArrayList<Double> data, int ext)
	{this(b,a,data,ext,FALSE);}
	public FastFilter(ArrayList<Double> b, ArrayList<Double> a, ArrayList<Double> data)
	{this(b,a,data,data.size()/2,FALSE);}

	public FastFilter(ArrayList<Double> b, ArrayList<Double> a, ArrayList<Double> data, int ext, Boolean zeroPhase)
	{
		this.b=b;
		this.a=a;
		this.data=data;
		this.ext=ext;
		this.zeroPhase=zeroPhase;
		
	}
}
