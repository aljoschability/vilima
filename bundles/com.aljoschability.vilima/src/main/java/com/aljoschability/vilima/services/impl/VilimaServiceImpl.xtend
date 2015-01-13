package com.aljoschability.vilima.services.impl

import com.aljoschability.vilima.services.VilimaService
import org.osgi.framework.BundleContext
import com.aljoschability.vilima.xtend.LogExtension
import com.aljoschability.vilima.Activator

class VilimaServiceImpl implements VilimaService {
	extension LogExtension = new LogExtension(typeof(VilimaServiceImpl), Activator::get)

	new(BundleContext context) {
		debug("created service")
	}

	override addFile(String path) {
		debug('''add file "«path»"...''')
	}
}
