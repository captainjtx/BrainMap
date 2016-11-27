package src.java;
import javax.swing.JList;
import javax.swing.DefaultListModel;

public class FileList extends JList {

	public FileList () {
	}
	public removeSelection(int index)
	{
		DefaultListModel model = (DefaultListModel) getModel();
		int selectedIndex = getSelectedIndex();
		if (selectedIndex != -1) {
			model.remove(selectedIndex);
		}
	}

}
