const express = require('express');
const execSh = require('exec-sh');

const app = express();
const port = 8333;

app.listen(port, () => {
  console.log('DFI Node.JS REST API runing on port ', port);
})

app.get('/', (request, response) => {
    response.send('OK');
});
  
app.get('/v1/getblockcount', (request, response) => {
    console.log('returning getblockcount to API');
    let command = "/opt/defi/bin/defi-cli getblockcount";
    execShellCommand(command, request, response);
});

app.get('/v1/getpoolpair', (request, response) => {
    console.log('returning getpoolpair to API');
    // TODO: Parse ID param as int to avoid passing directly to shell (insecure)
    let command = "/opt/defi/bin/defi-cli getpoolpair " + parseInt(request.query.id);
    execShellCommand(command, request, response)
});

function execShellCommand (cmd, request, response) {
  execSh(cmd, true,
    (err, stdout, stderr) => {
        if (err) console.log("error: ", cmd, err);
        if (stderr) console.log("stderr: ", cmd, stderr);
        // Not sending a JSON response since the CLI output contains line breaks
        // TODO: Parse out CLI line breaks to be able to send JSON response.
        response.send(stdout);
    });
}