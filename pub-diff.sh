#!/bin/bash
if [ $# -lt 2 ]; then
    echo "Usage:"
    echo "       $0 <dir1> <dir2>"
    echo "  or"
    echo "       $0 <dir1> <dir2> > <outputFile>"
    exit 1
fi
# Check existence
if [ ! -d "$1" ]; then
    echo "$1 specified as <dir1> does not exist"
    exit 1
fi

# Check existence
if [ ! -d "$2" ]; then
    echo "$2 specified as <dir2> does not exist"
    exit 1
fi

exclFile="./diff_exclude.txt"
if [ ! -f "$exclFile" ]; then
    echo "$exclFile does not exist."
    echo "Please create the file and place the following as the contents:"
    echo "---- Copy after this line ----"
    printf "*.json\n*.xml\n*.graphql\n*.ttl\n*.png\n*.shex\n*.sch\n*.xlsx\n*.js\n*.css\n*.zip\n*.gif\n*.tgz\n*.pack\nnamingsystem-terminologies.html\nnamingsystem-terminologies.json.html\nnamingsystem-terminologies.ttl.html\nnamingsystem-terminologies.xml.html\n*.shex.html\n*operation-everything.html\n*.jsonld"
    echo
    echo "---- End with the line above ----"
    exit 1
fi
# Regexes to exclude from diff
regEx[0]='[Gg]enerated on \(Fri\|Sat\|Sun\|Mon\|Tue\|Wed\|Thu\), \(Jan\|Feb\|Mar\|Apr\|May\|Jun\|Jul\|Aug\|Sep\|Oct\|Nov\|Dec\) [0-3][0-9], [0-9]\{4\} [0-9]\{2\}:[0-9]\{2\}'
regEx[1]='&quot;lastUpdated&quot; : &quot;[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}T'
regEx[2]='name=\"Resource.meta.lastUpdated\"> </a>value=\"<span class=\"xmlattrvalue\">[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}T'
regEx[3]='fhir:Meta.lastUpdated \[ fhir:value &quot;[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}T'
regEx[4]='fhir:\(CanonicalResource\|StructureDefinition\|CapabilityStatement\|ConceptMap\|CodeSystem\|ValueSet\|CompartmentDefinition\|OperationDefinition\).date \[ fhir:value &quot;[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}T'
regEx[5]='&quot;date&quot; : &quot;[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}T' 
regEx[6]='&lt;date value=&quot;[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}T' 
regEx[7]='name=\"\(StructureDefinition\|CanonicalResource\|CapabilityStatement\|ConceptMap\|CodeSystem\|ValueSet\|CompartmentDefinition\|OperationDefinition\).date\"> </a>value=\"<span class=\"xmlattrvalue\">[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}T' 
regEx[8]='&quot;\(identifier\|id\)&quot; : &quot;urn:uuid:[a-f0-9]\{8\}-[a-f0-9]\{4\}-[a-f0-9]\{4\}-[a-f0-9]\{4\}-[a-f0-9]\{12\}&quot;,' 
regEx[9]='&quot;timestamp&quot; : &quot;[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}T' 
regEx[10]='&lt;\(identifier\|id\) value=&quot;urn:uuid:[a-f0-9]\{8\}-[a-f0-9]\{4\}-[a-f0-9]\{4\}-[a-f0-9]\{4\}-[a-f0-9]\{12\}&quot;/&gt;' 
regEx[11]='&lt;id value=\"[a-f0-9]\{8\}-[a-f0-9]\{4\}-[a-f0-9]\{4\}-[a-f0-9]\{4\}-[a-f0-9]\{12\}\"/&gt;' 
regEx[12]='&lt;timestamp value=&quot;[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}T' 
regEx[13]='Published on [0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}T[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}[-+][0-9]\{2\}:[0-9]\{2\} by HL7 (FHIR Project)' 
regEx[14]='\(<\|&lt;\)img src=\(\"\|\\&quot;\)[a-f0-9]\{8\}-[a-f0-9]\{4\}-[a-f0-9]\{4\}-[a-f0-9]\{4\}-[a-f0-9]\{12\}.\(png\|gif\)\(\"\|\\&quot;\)' 
regEx[15]='src=\"<span class=\"xmlattrvalue\">[a-f0-9]\{8\}-[a-f0-9]\{4\}-[a-f0-9]\{4\}-[a-f0-9]\{4\}-[a-f0-9]\{12\}.\(png\|gif\)</span>\"' 
regEx[16]='\"date-time\": \"[0-9]\{14\}[-+][0-9]\{4\}\",' 
regEx[17]='\"[a-f0-9]\{8\}-[a-f0-9]\{4\}-[a-f0-9]\{4\}-[a-f0-9]\{4\}-[a-f0-9]\{12\}.\(png\|gif\)\",$' 
regEx[18]='date=[0-9]\{14\}'
regEx[19]='This expansion generated [0-3][0-9] \(Jan\|Feb\|Mar\|Apr\|May\|Jun\|Jul\|Aug\|Sep\|Oct\|Nov\|Dec\) [0-9]\{4\}'
regEx[20]='\(draft\|active\) as of [0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}'
regEx[21]='\"date\": \"[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\",' 
# Build string of exclusions
iString=""
for r in "${regEx[@]}"; do
  iString=$iString" -I '$r'"
done
diffCommand="diff -X $exclFile $iString $1 $2"
echo $diffCommand
eval "$diffCommand"


