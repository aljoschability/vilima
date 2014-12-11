package com.aljoschability.vilima.ui.parts

import com.aljoschability.vilima.MkAttachment
import com.aljoschability.vilima.MkFile
import com.aljoschability.vilima.ui.extensions.SwtExtension
import javax.annotation.PostConstruct
import javax.inject.Inject
import javax.inject.Named
import org.eclipse.e4.core.di.annotations.Optional
import org.eclipse.e4.ui.services.IServiceConstants
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.swt.SWT
import org.eclipse.swt.custom.SashForm
import org.eclipse.swt.events.ControlAdapter
import org.eclipse.swt.events.ControlEvent
import org.eclipse.swt.graphics.GC
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.Label
import com.aljoschability.vilima.extensions.ExtractExtension

class CoverPart {
	extension SwtExtension = SwtExtension::INSTANCE
	extension ExtractExtension = ExtractExtension::INSTANCE

	Label portraitLabel
	Label landscapeLabel

	MkFile file

	Image portraitImage

	Image landscapeImage

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
		val file = attachment.extract
		if(file != null && file.exists) {
			return new Image(Display::getCurrent, file.toString)
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

		portraitLabel = new Label(group, SWT::CENTER)
		portraitLabel.layoutData = newGridData(true, true)
		portraitLabel.addControlListener(
			new ControlAdapter {
				override controlResized(ControlEvent e) {
					paint(portraitLabel, portraitImage)
				}
			})
	}

	def private void createLandscapeGroup(Composite parent) {
		val group = newGroup(parent)
		group.layout = newGridLayoutSwt
		group.layoutData = newGridData(true, true)
		group.text = "Landscape Cover"

		landscapeLabel = new Label(group, SWT::CENTER)
		landscapeLabel.layoutData = newGridData(true, true)
		landscapeLabel.addControlListener(
			new ControlAdapter {
				override controlResized(ControlEvent e) {
					paint(landscapeLabel, landscapeImage)
				}
			})
	}

	def private void paint(Label composite, Image image) {
		if(image == null || composite == null || image.disposed || composite.disposed) {
			println('''something is null or disposed''')
			return
		}

		// dispose old image
		val oldImage = composite.image
		composite.image = null
		oldImage?.dispose

		// calculations
		val ix = image.imageData.width  as double
		val iy = image.imageData.height as double
		val iRatio = ix / iy

		val cx = composite.size.x as double
		val cy = composite.size.y as double
		val cRatio = cx / cy

		val limitY = cRatio - iRatio > 0

		var rx = cx
		var ry = cx * (iy / ix)
		if(limitY) {
			rx = cy * (ix / iy)
			ry = cy
		}

		// actually draw
		composite.image = resize(image, rx as int, ry as int)
	}

	def private Image resize(Image image, int width, int height) {
		val scaled = new Image(Display.getDefault(), width, height)
		val gc = new GC(scaled)
		gc.setAntialias(SWT::ON)
		gc.setInterpolation(SWT::HIGH)
		gc.drawImage(image, 0, 0, image.bounds.width, image.bounds.height, 0, 0, width, height)
		gc.dispose()

		//		image.dispose()
		return scaled
	}

	def private show(MkFile file) {
		this.file = file

		if(file.hasCovers) {
			if(portraitLabel != null && !portraitLabel.disposed) {
				val portraitAttachment = file.getAttachment("cover.jpg")

				if(portraitAttachment != null) {
					portraitLabel.redraw = false
					portraitImage = extractImage(portraitAttachment)
					portraitLabel.redraw = true
					portraitLabel.paint(portraitImage)
				}
			}

			if(landscapeLabel != null && !landscapeLabel.disposed) {
				val landscapeAttachment = file.getAttachment("cover_land.jpg")

				if(landscapeAttachment != null) {
					landscapeLabel.redraw = false
					landscapeImage = extractImage(landscapeAttachment)
					landscapeLabel.redraw = true
					landscapeLabel.paint(landscapeImage)
				}
			}
		} else {

			// dispose existing images
			if(portraitLabel != null && !portraitLabel.disposed) {
				val image = portraitLabel.image
				portraitLabel.image = null

				if(image != null) {
					image.dispose
				}
			}

			if(landscapeLabel != null && !landscapeLabel.disposed) {
				val image = landscapeLabel.image
				landscapeLabel.image = null

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
