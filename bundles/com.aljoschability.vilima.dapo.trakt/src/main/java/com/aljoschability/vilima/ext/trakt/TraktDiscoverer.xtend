package com.aljoschability.vilima.ext.trakt

import org.eclipse.core.runtime.jobs.Job
import org.eclipse.core.runtime.IProgressMonitor

class TraktDiscovererJob extends Job {
	new() {
		super("Discovering something from trakt.tv")
	}

	override run(IProgressMonitor monitor) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
}
