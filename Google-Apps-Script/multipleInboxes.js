//Author: Felipe Webb
//Purpose: Loops through user-defined labeled email threads and archives them
function automaticArchive() {

  //variable declaration
  var labelName;
  var emailThreads;
  var i;
  var thread;
  
  //find user-defined labels, which also default within the 'Inbox' label
  emailThreads = GmailApp.search('label:Inbox label:test-label OR label:test-label-2');
  for (i in emailThreads) {
    thread = emailThreads[i];
    thread.moveToArchive();
  } //end of looping through inbox
}
