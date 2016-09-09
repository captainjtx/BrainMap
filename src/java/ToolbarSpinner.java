package src.java;
import javax.swing.JSpinner;
import javax.swing.JFormattedTextField;
import javax.swing.SwingUtilities;
import javax.swing.JFrame;
import javax.swing.SpinnerModel;
import javax.swing.JComponent;
import java.awt.Window;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;

public class ToolbarSpinner extends JSpinner{
	public JFrame topWindow;
	public ToolbarSpinner(SpinnerModel model)
	{
		super(model);
		JFormattedTextField text=((JSpinner.DefaultEditor)this.getEditor()).getTextField();
		text.addKeyListener( new KeyAdapter() {
			@Override
			public void keyReleased( final KeyEvent e ) {
				if ( e.getKeyCode() == KeyEvent.VK_ESCAPE||e.getKeyCode()==KeyEvent.VK_ENTER) {
					topWindow=(JFrame) SwingUtilities.getWindowAncestor(ToolbarSpinner.this);
					if (topWindow!=null)
					{
						topWindow.requestFocus();
					}
				}
			}
		} );
	}
}
