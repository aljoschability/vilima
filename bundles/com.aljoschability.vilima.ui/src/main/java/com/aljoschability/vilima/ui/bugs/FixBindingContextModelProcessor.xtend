package com.aljoschability.vilima.ui.bugs

import org.eclipse.e4.core.di.annotations.Execute
import org.eclipse.e4.ui.model.application.MApplication
import com.aljoschability.vilima.ui.Activator

/* fixes removed key bindings by adding a <code>type:user</code> tag to each defined binding.
 * @see http://techblog.ralph-schuster.eu/2013/10/13/eclipsee4-problem-with-key-bindings/comment-page-1
 * @see http://www.eclipse.org/forums/index.php/t/550175
 */
class FixBindingContextModelProcessor {
	static val MAGIC_TAG = "type:user"

	@Execute
	def void execute(MApplication application) {
		for (table : application.bindingTables) {
			debug('''processing table «table»''')
			for (binding : table.bindings) {
				debug('''processing binding «binding»''')
				if(!binding.tags.contains(MAGIC_TAG)) {
					binding.tags += MAGIC_TAG
				}
			}
		}
	}

	private def void debug(String message) {
		Activator::get.debug('''[FixBindingContextModelProcessor] «message»''')
	}
}
