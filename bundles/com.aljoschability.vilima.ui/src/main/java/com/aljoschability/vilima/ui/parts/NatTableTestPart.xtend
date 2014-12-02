package com.aljoschability.vilima.ui.parts

import com.aljoschability.vilima.VilimaEventTopics
import com.aljoschability.vilima.XVilimaLibrary
import java.util.Date
import javax.annotation.PostConstruct
import javax.inject.Inject
import org.eclipse.e4.core.di.annotations.Optional
import org.eclipse.e4.ui.di.UIEventTopic
import org.eclipse.nebula.widgets.nattable.NatTable
import org.eclipse.nebula.widgets.nattable.data.IDataProvider
import org.eclipse.nebula.widgets.nattable.data.ListDataProvider
import org.eclipse.nebula.widgets.nattable.data.ReflectiveColumnPropertyAccessor
import org.eclipse.nebula.widgets.nattable.grid.data.DefaultColumnHeaderDataProvider
import org.eclipse.nebula.widgets.nattable.grid.data.DefaultCornerDataProvider
import org.eclipse.nebula.widgets.nattable.grid.data.DefaultRowHeaderDataProvider
import org.eclipse.nebula.widgets.nattable.grid.layer.ColumnHeaderLayer
import org.eclipse.nebula.widgets.nattable.grid.layer.CornerLayer
import org.eclipse.nebula.widgets.nattable.grid.layer.GridLayer
import org.eclipse.nebula.widgets.nattable.grid.layer.RowHeaderLayer
import org.eclipse.nebula.widgets.nattable.hideshow.ColumnHideShowLayer
import org.eclipse.nebula.widgets.nattable.layer.AbstractLayerTransform
import org.eclipse.nebula.widgets.nattable.layer.DataLayer
import org.eclipse.nebula.widgets.nattable.reorder.ColumnReorderLayer
import org.eclipse.nebula.widgets.nattable.selection.SelectionLayer
import org.eclipse.nebula.widgets.nattable.viewport.ViewportLayer
import org.eclipse.swt.widgets.Composite
import org.eclipse.xtend.lib.annotations.Data

class NatTableTestPart {

	NatTable table

	@PostConstruct
	def void create(Composite parent) {

		table = new NatTable(parent, true)
	}

	@Inject @Optional
	def handleRefresh(@UIEventTopic(VilimaEventTopics::CONTENT_REFRESH) XVilimaLibrary content) {
		if(table != null) {
			println('''refresh table''')
		}
	}

	@Deprecated
	def private void testExample(Composite parent) {
		val people = newArrayList
		people += new Person(1, "name1", new Date())
		people += new Person(1, "name2", new Date())
		people += new Person(1, "name3", new Date())

		val propertyNames = #["id", "name", "birthDate"]
		val bodyDataProvider = new ListDataProvider(people, new ReflectiveColumnPropertyAccessor(propertyNames));

		val bodyLayer = new BodyLayerStack(bodyDataProvider)

		val columnHeaderLayer = new ColumnHeaderLayerStack(bodyDataProvider, bodyLayer)
		val rowHeaderLayer = new RowHeaderLayerStack(bodyDataProvider, bodyLayer)

		// Setting up the corner layer
		val rowHeaderDataProvider = new DefaultRowHeaderDataProvider(bodyDataProvider)
		val colHeaderDataProvider = new DefaultColumnHeaderDataProvider(#["ID", "Name", "Date"])

		val cornerDataProvider = new DefaultCornerDataProvider(colHeaderDataProvider, rowHeaderDataProvider);
		val cornerLayer = new CornerLayer(new DataLayer(cornerDataProvider), rowHeaderLayer, columnHeaderLayer);

		// Drum roll ...
		val gridLayer = new GridLayer(bodyLayer, columnHeaderLayer, rowHeaderLayer, cornerLayer);
		val natTable = new NatTable(parent, gridLayer);
		println(natTable)
	}
}

@Data
class Person {
	int id
	String name
	Date birthDate
}

// Setting up the body region
class BodyLayerStack extends AbstractLayerTransform {

	SelectionLayer selectionLayer

	new(IDataProvider dataProvider) {
		val bodyDataLayer = new DataLayer(dataProvider)
		val columnReorderLayer = new ColumnReorderLayer(bodyDataLayer)
		val columnHideShowLayer = new ColumnHideShowLayer(columnReorderLayer)
		selectionLayer = new SelectionLayer(columnHideShowLayer)
		val viewportLayer = new ViewportLayer(selectionLayer)
		setUnderlyingLayer(viewportLayer)
	}

	def SelectionLayer getSelectionLayer() {
		return selectionLayer
	}
}

// Setting up the column header region
class ColumnHeaderLayerStack extends AbstractLayerTransform {
	new(IDataProvider dataProvider, BodyLayerStack bodyLayer) {
		val dataLayer = new DataLayer(dataProvider)
		val colHeaderLayer = new ColumnHeaderLayer(dataLayer, bodyLayer, bodyLayer.getSelectionLayer())
		setUnderlyingLayer(colHeaderLayer)
	}
}

// Setting up the row header layer
class RowHeaderLayerStack extends AbstractLayerTransform {
	new(IDataProvider dataProvider, BodyLayerStack bodyLayer) {
		val dataLayer = new DataLayer(dataProvider, 50, 20);
		val rowHeaderLayer = new RowHeaderLayer(dataLayer, bodyLayer, bodyLayer.getSelectionLayer());
		setUnderlyingLayer(rowHeaderLayer);
	}
}
