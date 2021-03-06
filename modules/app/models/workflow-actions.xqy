xquery version "1.0-ml";

module namespace m="http://marklogic.com/workflow-actions";

import module namespace wfu="http://marklogic.com/workflow-util" at "/app/models/workflow-util.xqy";

declare namespace prop = "http://marklogic.com/xdmp/property";
declare namespace wf="http://marklogic.com/workflow";
declare namespace p="http://marklogic.com/cpf/pipelines";
declare namespace error="http://marklogic.com/xdmp/error";

(:
 : This library holds complementary actions for CPF actions for BPMN2 steps.
 : E.g. a user task CPF action pauses the workflow, whereas a complementary method here uses that step information
 : and continues the workflow.
 :)

(: EXTERNAL CALLABLE FUNCTIONS - update-* updates the task, but does not complete it. complete-* does update and complete. :)

declare function update-userTask($processId as xs:string,$data as node()*,$attachments as node()*) as node()? {
  let $_ := xdmp:log("In wfa:update-userTask")
  return
  update-generic($processId,$data,$attachments)
};

(:
 : Complete a user task, moving it on to the next step. (Just marks as complete)
 :)
declare function complete-userTask($processId as xs:string,$data as node()*,$attachments as node()*) as node()? {
  let $_ := xdmp:log("In wfa:complete-userTask")
  (: Find process document :)
  (: Get next step ID :)
  (: TODO check required attachments and properties here (Should be done in the UI) :)
  let $update := update-userTask($processId,$data,$attachments)
  (: TODO lookup functionality from document patch in REST API to see if we can replicate that method here :)
  return
    if (fn:empty($update)) then complete-generic($processId) else $update
};



(: INTERNAL METHODS :)
declare function update-generic($processId as xs:string,$data as node()*,$attachments as node()*) as node()? {
  let $_ := xdmp:log("In wfa:update-generic")
  (: TODO complete this method :)
  (: TODO security sanity checks - ensure nothing is updated that shouldn't be :)
  (: Complete step and move on :)
  let $updateData :=
    for $dn in $data
    return
      ()
  let $updateAttachments := ()
  return ()
};

(:
 : Marks as complete ONLY. Does not call wfu:complete
 :)
declare function complete-generic($processId as xs:string) as empty-sequence() {
  let $_ := xdmp:log("In wfa:complete-generic: processId: "||$processId)
  let $props := wfu:getProperties($processId)
  let $_ := xdmp:log($props)
  let $next := $props/wf:currentStep/wf:state/text()
  let $_ := xdmp:log($next)
  let $transition := $props/wf:currentStep/wf:state-transition/text()
  let $_ := xdmp:log($transition)
  let $startTime := xs:dateTime($props/wf:currentStep/wf:startTime)
  let $_ := xdmp:log($startTime)
  (:let $update := xdmp:document-remove-properties(wfu:getProcessUri($processId),xs:QName("wf:currentStep")) :)
  (:let $update := xdmp:node-delete($props/wf:currentStep)
  let $_ := xdmp:log($update) :)
  return
    (: wfu:completeById($processId,$transition,xs:anyURI($next),$startTime) :)
    wfu:inProgress($processId,$transition)
};
