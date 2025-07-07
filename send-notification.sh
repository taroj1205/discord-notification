#!/bin/bash
# This script builds and sends a Discord notification.
# It exits immediately if a command fails.
set -euo pipefail

# Build the JSON payload using jq.
# This approach is safer than embedding shell variables in a string.
# We conditionally build the JSON object, only adding keys if their
# corresponding input values are not null or empty.
JSON_PAYLOAD=$(jq -n \
  --arg title "$INPUT_TITLE" \
  --arg description "$INPUT_DESCRIPTION" \
  --arg description_max_length "${INPUT_DESCRIPTION_MAX_LENGTH:-}" \
  --argjson color "$INPUT_COLOR" \
  --arg url "$INPUT_URL" \
  --arg image_url "$INPUT_IMAGE_URL" \
  --arg author_name "$INPUT_AUTHOR_NAME" \
  --arg author_url "$INPUT_AUTHOR_URL" \
  --arg author_icon_url "$INPUT_AUTHOR_ICON_URL" \
  --arg button_label "$INPUT_BUTTON_LABEL" \
  --arg branch_info "$INPUT_BRANCH_INFO" \
  '
    {
      "embeds": [
        {
          "title": $title,
          "description": (
            if ($description_max_length | test("^[0-9]+$")) and (($description_max_length | tonumber) > 0) then
              ($description_max_length | tonumber) as $max_length |
              if ($description | length) > $max_length then
                if $max_length > 3 then
                  ($description | .[0:$max_length - 3]) + "..."
                else
                  $description | .[0:$max_length]
                end
              else
                $description
              end
            else
              $description
            end
          ),
          "color": $color
        }
        + (if $url != "" then {url: $url} else {} end)
        + (if $image_url != "" then {image: {url: $image_url}} else {} end)
        + (if $author_name != "" then {author: {name: $author_name, url: $author_url, icon_url: $author_icon_url}} else {} end)
        + (if $branch_info != "" then {fields: [{name: "Branch", value: $branch_info, inline: false}]} else {} end)
      ]
    }
    + (if $url != "" then
      {
        "components": [
          {
            "type": 1,
            "components": [
              { "type": 2, "label": $button_label, "style": 5, "url": $url }
            ]
          }
        ]
      }
      else {} end)
  ')

# Send the payload to the Discord webhook URL.
curl -X POST -H "Content-Type: application/json" \
  -d "$JSON_PAYLOAD" \
  "$INPUT_WEBHOOK_URL?with_components=true" 