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
        function local_basename(path) {
            var basename = path.split(/[\\/]/).pop();
            return basename
        }
    
        var grnFilePath = inputs.green_idat.location;
        var redFilePath = inputs.red_idat.location;
        var grnFileName = local_basename(grnFilePath); 
        var redFileName = local_basename(redFilePath);
        var newGrnName = (endsWith(grnFileName,'_Grn.idat') || endsWith(grnFileName,'_Grn.idat.gz')) ? grnFileName:grnFileName+'_Grn.idat';
        var newRedName = (endsWith(redFileName,'_Red.idat') || endsWith(redFileName,'_Red.idat.gz')) ? redFileName:redFileName+'_Red.idat';
    
        return {'newGrnName':newGrnName,'newRedName':newRedName}
    }
