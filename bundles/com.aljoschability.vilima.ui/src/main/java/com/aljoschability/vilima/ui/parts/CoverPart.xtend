package com.aljoschability.vilima.ui.parts

import com.aljoschability.vilima.MkAttachment
import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.ui.Activator
import com.aljoschability.vilima.ui.extensions.SwtExtension
import com.google.common.io.CharStreams
import com.google.common.io.Files
import java.io.BufferedReader
import java.io.File
import java.io.InputStreamReader
import java.nio.file.Paths
import javax.annotation.PostConstruct
import javax.inject.Inject
import javax.inject.Named
import org.eclipse.e4.core.di.annotations.Optional
import org.eclipse.e4.ui.services.IServiceConstants
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.swt.SWT
import org.eclipse.swt.custom.SashForm
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.Label
import org.eclipse.swt.widgets.Canvas
import org.eclipse.swt.graphics.GC

class CoverPart {
	extension SwtExtension = SwtExtension::INSTANCE

	Canvas portraitCanvas
	Label landscapeCanvas

	MkFile file

	Image portraitImage

	@PostConstruct
	def postConstruct(Composite parent) {
		val composite = newComposite(parent)
		composite.layout = newGridLayout
		composite.layoutData = newGridData(true, true)

		val sash = new SashForm(composite, SWT::HORIZONTAL)
		sash.layoutData = newGridData(true, true)

		createPortraitGroup(sash)

		createLandscapeGroup(sash)

		sash.weights = #[1, 1]
	}

	def private Image extractImage(MkAttachment attachment) {
		val inFile = Paths::get(file.path, file.name).toFile
		val outFile = File::createTempFile(attachment.name, "." + Files::getFileExtension(attachment.name))
		val id = file.attachments.indexOf(attachment)
		val command = '''mkvextract attachments "«inFile»" «id + 1»:"«outFile»"'''

		val process = Runtime::getRuntime.exec(command)
		if(process.waitFor == 0) {
			val stdInput = new BufferedReader(new InputStreamReader(process.inputStream))

			//println(CharStreams::toString(stdInput))
			Activator::get.info(CharStreams::toString(stdInput))

			if(outFile.exists) {
				return new Image(Display::getCurrent, outFile.toString)
			}
		} else {
			val stdInput = new BufferedReader(new InputStreamReader(process.inputStream))
			val stdError = new BufferedReader(new InputStreamReader(process.errorStream))

			println('''error running command: «command»''')
			println(CharStreams::toString(stdInput))
			println(CharStreams::toString(stdError))
		}

		return null
	}

	def private MkAttachment getAttachment(MkFile file, String name) {
		if(file != null) {
			for (attachment : file.attachments) {
				if(attachment.name == name) {
					return attachment
				}
			}
		}
		return null
	}

	def private void createPortraitGroup(Composite parent) {
		val group = newGroup(parent)
		group.layout = newGridLayoutSwt
		group.layoutData = newGridData(true, true)
		group.text = "Portrait Cover"

		portraitCanvas = new Canvas(group, SWT::BORDER)
		portraitCanvas.layoutData = newGridData(true, true)
		portraitCanvas.addPaintListener(
			[ e |
				if(portraitImage != null && !portraitImage.disposed) {
					val width = portraitCanvas.clientArea.width
					val height = portraitCanvas.clientArea.height
					e.gc.drawImage(resize(portraitImage, width, height), 0, 0)
				}
			])
	}

	def private Image resize(Image image, int width, int height) {
		println('''image       : w=«image.imageData.width»; h=«image.imageData.height»''')
		println('''canvas[size]: w=«portraitCanvas.size.x»; h=«portraitCanvas.size.y»''')
		println('''canvas[area]: w=«portraitCanvas.clientArea.x»; h=«portraitCanvas.clientArea.y»''')

		val scaled = new Image(Display.getDefault(), width, height)
		val gc = new GC(scaled)
		gc.setAntialias(SWT::ON)
		gc.setInterpolation(SWT::HIGH)
		gc.drawImage(image, 0, 0, image.bounds.width, image.bounds.height, 0, 0, width, height)
		gc.dispose()
		image.dispose()
		return scaled
	}

	def private void createLandscapeGroup(Composite parent) {
		val group = newGroup(parent)
		group.layout = newGridLayoutSwt
		group.layoutData = newGridData(true, true)
		group.text = "Landscape Cover"

		landscapeCanvas = new Label(group, SWT::NONE)
		landscapeCanvas.layoutData = newGridData(true, true)
	}

	def private show(MkFile file) {
		this.file = file

		if(file.hasCovers) {
			if(portraitCanvas != null && !portraitCanvas.disposed) {
				val portraitAttachment = file.getAttachment("cover.jpg")

				if(portraitAttachment != null) {
					portraitCanvas.redraw = false
					portraitImage = extractImage(portraitAttachment)
					portraitCanvas.redraw = true
				}
			}

			if(landscapeCanvas != null && !landscapeCanvas.disposed) {
				val landscapeAttachment = file.getAttachment("cover_land.jpg")

				if(landscapeAttachment != null) {
					landscapeCanvas.image = extractImage(landscapeAttachment)
					val data = landscapeCanvas.image.imageData

					println('''cover_land.jpg («data.width» x «data.height»)''')
				}
			}
		} else {

			// dispose existing images
			if(portraitCanvas != null && !portraitCanvas.disposed) {
				//				val image = portraitCanvas.image
				//				portraitCanvas.image = null
				//
				//				if(image != null) {
				//					image.dispose
				//				}
			}

			if(landscapeCanvas != null && !landscapeCanvas.disposed) {
				val image = landscapeCanvas.image
				landscapeCanvas.image = null

				if(image != null) {
					image.dispose
				}
			}
		}
	}

	def boolean hasCovers(MkFile file) {
		if(file != null) {
			for (attachment : file.attachments) {
				if(attachment.name == "cover.jpg" || attachment.name == "cover_land.jpg") {
					return true
				}
			}
		}
		return false
	}

	@Inject
	def void handleSelection(@Optional @Named(IServiceConstants.ACTIVE_SELECTION) IStructuredSelection selection) {
		var MkFile file = null
		if(selection != null && selection.size() == 1) {
			val selected = selection.getFirstElement();
			if(selected instanceof MkFile) {
				file = selected
			}
		}
		show(file)
	}
}
