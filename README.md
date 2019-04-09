# HAT240
A homework auto-tester for Purdue's CS 240 class.

Feel free to modify and share this however you like!

# What does this do?

This script is the result of a lot of frustration I encountered while testing my homework for CS240. Whether it was errors or it was weird inputs, I always seemed to have *some* issue. Thus, this was born. It features quite a few nifty features for whosoever needs to run multiple tests on their homework code.

### Generalized usage
You can run this from anywhere you want on whichever test file you want however many times you want. You can use it all in one line by passing in arguments or you can use the prompts (however the prompts do not allow for customization of target score).

### Logging
Keeps track of your test failures. In addition to keeping count and giving you the final count at the end, all failures are put in a log file inside of a folder the script creates called "test_failures" and all files associated with said test failure, including the complete test log for that run, are put in their own unique directory within the same directory. Additionally, HAT240 will tell you which of your failures has the lowest score, so you can find the problem inputs immediately.

### Progress
You can keep track of how close you are to completion with a progress bar that both shows overall progression and the current test being run.

### Simple to Change Goals
By passing in a different target score, you can set what you hope to achieve from any specific test batch. This allows for working on the homework on both a function by function basis and all at once.

### Control
You may control and keep track of your testing with built in commands while your testing is being run. You can check the number of failures, abort testing, pause testing, and more!

# How do I use this?

HAT240 was made to save time, so the usage is built around time saving as well. You can pass in arguments to run it all in one line. All arguments are optional, but if the first two are not provided, you will be prompted for them:

```hat240.sh arg1 arg2 arg3```

**arg1** = compiled_hw_test_file

**arg2** = number_of_tests_to_run

**arg3** = target_score (default = 100)

# Need help?
If you don't have permission to run the .sh file, run the following command:

```chmod +x hat240.sh```

For my Windows friends, the following command will fix this script after you save your changes. Windows likes to use different line endings, so this will change them to allow for proper compilation:

```sed -i -e 's/\r$//' hat240.sh```

# License

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
