#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
	- class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
	- id: red_idat
	  type: File
	- id: green_idat
	  type: File

outputs:
	- id: newRedName
	  type: string
	- id: newGrnName
	  type: string

expression: |
	${
		// https://stackoverflow.com/a/2548133/810957
		function endsWith(str, suffix) {
			return str.indexOf(suffix, str.length - suffix.length) !== -1;
		}

		// https://stackoverflow.com/questions/3820381/need-a-basename-function-in-javascript#comment29942319_15270931
		fuction local_basename(path) {
			var basename = path.split(/[\\/]/).pop();
			return basename
		}

		function get_slice_number(idat_name) {
			if (endsWith(idat_name, '_Grn.idat')) {
				return -9
			}
			else if (endsWith(idat_name, '_Red.idat')) {
				return -9
			}
			else if (endsWith(idat_name, '_Grn.idat.gz')) {
				return -12
			}
			else if (endsWith(idat_name, '_Red.idat.gz')) {
				return -12
			} else {
				throw "unrecognized idat extension"
			}
		}

		var grnFilePath = inputs.green_idat.path;
		var redFilePath = inputs.red_idat.path;
		var grnFileName = local_basename(grnFilePath);
		var redFileName = local_basename(redFilePath);

		// Files will either have a proper slice or error is thrown
		var grnSlice = get_slice_number(grnFileName);
		var redSlice = get_slice_number(redFilename);

		var grnBaseName = grnFileName.slice(0,grnSlice);
		var grnExt = grnFileName.slice(grnSlice);
		var redBaseName = redFilename.slice(0,redSlice);
		var redExt = redFilename.slice(redSlice);

		// Files have proper suffixes and the same basename; no action needed
		if (grnBaseName == redBaseName) {
			return {'newRedName':redFileName,'newGrnName':grnFileName}
		}
		// Files have proper suffixes but different basenames; use Green basename
		else {
			var newRedName = grnBaseName + redExt;
			var newGrnName = grnFileName;
			return {'newRedName': newRedName,'newGrnName': newgrnName}
		}
	}
