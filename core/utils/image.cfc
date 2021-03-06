﻿<cfcomponent>
	<cffunction name="upload" access="remote" returntype="struct" returnformat="json" output="false">
		<cfscript>
			var uploadDir = expandPath('.') & '/uploads/'; // should be a temp directory that you clear periodically to flush orphaned files 
			var uploadFile =  uploadDir & arguments.NAME;
			var response = {'result' = arguments.NAME, 'id' = 0};
			var result = {};
			// if chunked append chunk number to filename for reassembly
			if (structKeyExists(arguments, 'CHUNKS'))
			{
				uploadFile = uploadFile & '.' & arguments.CHUNK;
				response.id = arguments.CHUNK;
			}
		</cfscript>
		<!--- save file data from multi-part form.FILE --->
		<cffile action="upload" result="result" filefield="FILE" destination="#uploadFile#" nameconflict="overwrite"/>
		<cfscript>
			// Example: you can return uploaded file data to client 
			response['size'] = result.fileSize;
			response['type'] = result.contentType;
			response['saved'] = result.fileWasSaved;
			// reassemble chunked file
			if (structKeyExists(arguments, 'CHUNKS') && arguments.CHUNK + 1 == arguments.CHUNKS)
			{
				try {
					var uploadFile = uploadDir & arguments.NAME; // file name for reassembled file - if using a temp directory then this should be the final output path/file
					if (fileExists(uploadFile))
					{
						fileDelete(uploadFile); // delete otherwise append will add chunks to an existing file
					}
					var tempFile = fileOpen(uploadFile,'append');
					for (var i = 0; i < arguments.CHUNKS; i++) 
					{
						var chunk = fileReadBinary('#uploadDir#/#arguments.NAME#.#i#');
						fileDelete('#uploadDir#/#arguments.NAME#.#i#');
						fileWrite(tempFile, chunk);
					}
					fileClose(tempFile);
				}
				catch(any err){
					// clean up chunks for incomplete upload
					var d = directoryList(uploadDir,false,'name');
					if (arrayLen(d) != 0)
					{
						for (var i = 1; i <= arrayLen(d); i++)
						{
							if (listFirst(d[i]) == arguments.NAME && val(listLast(d[i])) != 0)
							{
								fileDelete('#uploadDir##d[i]#');
							}
						}
					}
					// you could add more error handling and return info from err 
					response = {'error' = {'code' = 500, 'message' = 'Internal Server Error'}, 'id' = 0};  
				}
			}
			return response;
		</cfscript>
	</cffunction>
</cfcomponent>
