-- this is the init file that's being executed first

-- by default changes you make will not be effected until 
-- the editor is restarted.
-- in order module to recompile when referenced, existing 
-- module needs to be removed.
-- this really helps when developing plugins
package.loaded['helloworld'] = nil
require('helloworld')()

