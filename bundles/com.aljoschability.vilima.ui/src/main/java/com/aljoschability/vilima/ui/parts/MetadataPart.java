package com.aljoschability.vilima.ui.parts;

import java.io.File;
import java.io.IOException;

import javax.annotation.PostConstruct;

import org.eclipse.jface.layout.GridDataFactory;
import org.eclipse.jface.layout.GridLayoutFactory;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.FileDialog;
import org.eclipse.swt.widgets.Label;

import com.aljoschability.vilima.MkvFile;
import com.aljoschability.vilima.VilimaFactory;
import com.aljoschability.vilima.reading.MatroskaReader;

public class MetadataPart {
	@PostConstruct
	public void create(Composite parent) {
		Composite composite = new Composite(parent, SWT.NONE);
		composite.setLayout(GridLayoutFactory.swtDefaults().create());

		createFileGroup(composite);

		createButton(composite);
	}

	private void createFileGroup(Composite parent) {
		Composite composite = new Composite(parent, SWT.NONE);
		composite.setLayout(GridLayoutFactory.swtDefaults().numColumns(2).create());
		composite.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());

		// title
		Label nameLabel = new Label(composite, SWT.LEAD);
		nameLabel.setText("Title");

		Combo nameData = new Combo(composite, SWT.DROP_DOWN);
		nameData.setLayoutData(GridDataFactory.fillDefaults().grab(true, false).create());
		// labelsMap.put("file.name", nameData)
	}

	private void createButton(Composite parent) {
		Button button = new Button(parent, SWT.PUSH);
		button.setText("Load...");
		button.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				FileDialog dialog = new FileDialog(button.getShell(), SWT.OPEN);

				String result = dialog.open();
				if (result != null) {
					File file = new File(result);

					MatroskaReader reader = new MatroskaReader();

					MkvFile mkv = VilimaFactory.eINSTANCE.createMkvFile();
					mkv.setFileDate(file.lastModified());
					mkv.setFileName(file.getName());
					mkv.setFilePath(file.getParent());
					mkv.setFileSize(file.length());

					try {
						reader.readFile(mkv);
					} catch (IOException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}

					show(mkv);
				}

			}
		});
	}

	private void show(MkvFile file) {
		System.out.println("show " + file);
	}
}
