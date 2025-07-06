# Discord Notification GitHub Action

A fast, flexible, and lightweight GitHub Action to send highly customizable notifications to a Discord channel using webhooks.

![Example Notification](https://opengraph.githubassets.com/9fe2bf92b5205d884ef2bbe4983f04525ec921e1d417354ca54b89597c7e1e3f/taroj1205/discord-notification/pull/13)

## ✨ Features

- **Rich Embeds**: Send structured and visually appealing messages using Discord's embed capabilities.
- **Fully Customizable**: Control every part of the message, including title, description, color, author, images, and more.
- **Interactive Buttons**: Add a button to your notification that links directly to a URL, such as a pull request or a project board.
- **Lightweight & Fast**: Built with a minimal shell script (`bash`) and `jq`, this action has no heavy dependencies and runs instantly.
- **Conditional Logic**: The action is smart enough to only show components (like buttons or author info) when you provide the necessary inputs.

## 📖 Usage

### Basic Notification

This example sends a simple notification. Only `title` and `description` are required.

```yaml
name: CI
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Send notification
        uses: taroj1205/testing-repo@v1
        with:
          webhook_url: ${{ secrets.DISCORD_WEBHOOK_URL }}
          title: 'Build Complete'
          description: 'The latest build has completed successfully.'
```

### Pull Request Notification

This example shows a more advanced notification that could be used for pull requests. It includes a link button, an author, and the Open Graph image from the PR.

```yaml
name: Pull Request Notification
on:
  pull_request:
    types: [opened]

jobs:
  notify:
    runs-on: ubuntu-latest
    steps:
      - name: Send PR Notification
        uses: taroj1205/testing-repo@v1
        with:
          webhook_url: ${{ secrets.DISCORD_WEBHOOK_URL }}
          title: 'PR Ready for Review: ${{ github.event.pull_request.title }}'
          description: ${{ github.event.pull_request.body }}
          url: ${{ github.event.pull_request.html_url }}
          image_url: 'https://opengraph.githubassets.com/${{ github.sha }}/${{ github.repository }}/pull/${{ github.event.pull_request.number }}'
          author_name: ${{ github.event.pull_request.user.login }}
          author_url: ${{ github.event.pull_request.user.html_url }}
          author_icon_url: ${{ github.event.pull_request.user.avatar_url }}
          button_label: 'View Pull Request'
```

## 📋 Inputs

| Input           | Description                                                                    | Required | Default             |
| --------------- | ------------------------------------------------------------------------------ | -------- | ------------------- |
| `webhook_url`   | The Discord webhook URL.                                                       | **Yes**  | `N/A`               |
| `title`         | The title of the embed.                                                        | **Yes**  | `N/A`               |
| `description`   | The description of the embed. Supports GitHub-flavored markdown.               | **Yes**  | `N/A`               |
| `color`         | The decimal color of the embed.                                                | No       | `3447003` (Blue)    |
| `url`           | The URL the embed title links to. Also used for the button if one is present.  | No       | `N/A`               |
| `image_url`     | The URL of the main image in the embed.                                        | No       | `N/A`               |
| `author_name`   | The name of the embed author.                                                  | No       | `N/A`               |
| `author_url`    | The URL of the embed author.                                                   | No       | `N/A`               |
| `author_icon_url`| The icon URL of the embed author.                                              | No       | `N/A`               |
| `button_label`  | The label for the button. The button will only be shown if a `url` is provided. | No       | `"View Details"`    |
| `branch_info`   | The branch information to display in a field (e.g., `` `head` -> `base` ``).      | No       | `N/A`               |

## 🛠️ Development

To contribute, clone the repository, make your changes, and open a pull request. This project uses `release-please` to automate releases, so please follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification for your commit messages.

## 📄 License

This project is licensed under the MIT License - see the `LICENSE` file for details.
