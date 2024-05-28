# Contributing to SharingHub

First off, thanks for taking the time to contribute! 🎉

The following is a set of guidelines for contributing to SharingHub. These are mostly guidelines, not rules.

## How Can I Contribute?

### Reporting Issues

Issue tracker: <https://github.com/csgroup-oss/sharingub/issues>

If you find a bug, please create an issue in the issue tracker and provide the following information:

- **Description**: Provide a clear and concise description of the problem.
- **Steps to Reproduce**: List the steps to reproduce the problem.
- **Expected Behavior**: Describe what you expected to happen.
- **Actual Behavior**: Describe what actually happened.
- **Screenshots**: If applicable, add screenshots to help explain your problem.
- **Environment**: Provide information about your environment, such as your operating system and version, and the version of the project you are using.

### Suggesting Enhancements

If you have an idea to improve the project, we would love to hear it! Please create an issue and provide the following information:

- **Description**: Provide a clear and concise description of the enhancement.
- **Rationale**: Explain why this enhancement would be useful.
- **Implementation**: If possible, describe how you would implement the enhancement.

### Submitting Pull Requests

1. **Fork the Repository**: Create a fork of the repository by clicking the "Fork" button on the repository page.
2. **Clone the Fork**: Clone your fork to your local machine.

   ```shell
   git clone https://github.com/csgroup-oss/sharinghub-server.git
   cd sharinhub
   python3 -mvenv .venv
   source .venv/bin/activate
   pip install pre-commit
   pre-commit install --install-hooks
   git checkout -b deploy/your-topic-name

   ```

3. **Commit changes**: Commit your changes with a clear and concise commit message.
4. **Push changes**: Push your changes to your fork

   ```shell
   git push origin deploy/your-topic-name
   ```

5. **Create a Pull Request**: Create a pull request from your fork's branch to the main repository's main branch. Provide a clear and concise description of your changes and the problem they address.

#### Code Styles

- Follow the style conventions used in the project.
- Ensure your code is well-documented and commented.
- Write clear and concise commit messages.

#### Code of Conduct

This project adheres to the [Code of Conduct](./CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to <support@csgroup.eu>.

### Additional Resources

- [Issue Tracker](https://github.com/csgroup-oss/sharinghub/issues)
- [Code of Conduct](./CODE_OF_CONDUCT.md)
