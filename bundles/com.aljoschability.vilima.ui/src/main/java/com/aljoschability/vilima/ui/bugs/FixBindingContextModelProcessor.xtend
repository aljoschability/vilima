package com.aljoschability.vilima.ui.bugs

import org.eclipse.e4.ui.model.application.MApplication
import org.eclipse.e4.core.di.annotations.Execute

/* fixes removed key bindings by adding a <code>type:user</code> tag to each defined binding.
 * @see http://techblog.ralph-schuster.eu/2013/10/13/eclipsee4-problem-with-key-bindings/comment-page-1
 * @see http://www.eclipse.org/forums/index.php/t/550175
 */
class FixBindingContextModelProcessor {
	static val MAGIC_TAG = "type:user"

	@Execute
	def void execute(MApplication application) {
		for (table : application.bindingTables) {
			for (binding : table.bindings) {
				if(!binding.tags.contains(MAGIC_TAG)) {
					binding.tags += MAGIC_TAG

					println('''added "type:user" tag to binding: («binding.keySequence») «binding.command.elementId»''')
				}

			//println('''«binding.command.elementId»''')
			}
		}
	}
}
