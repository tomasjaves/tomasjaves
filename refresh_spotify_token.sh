#!/bin/bash

CLIENT_ID="439eaa14c3f8479192ad9460ee2d9311"
CLIENT_SECRET="73540d65013c46dc8e56f4474117b6e7"
REFRESH_TOKEN="${{ secrets.SPOTIFY_REFRESH_TOKEN }}"

# Obtener nuevo Access Token desde el Refresh Token
RESPONSE=$(curl -s -X POST "https://accounts.spotify.com/api/token" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "grant_type=refresh_token" \
    -d "refresh_token=$REFRESH_TOKEN" \
    -d "client_id=$CLIENT_ID" \
    -d "client_secret=$CLIENT_SECRET")

ACCESS_TOKEN=$(echo $RESPONSE | jq -r '.access_token')

# Subir el nuevo Access Token a GitHub Secrets
curl -X PUT -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/repos/tomasjaves/tomasjaves/actions/secrets/SPOTIFY_ACCESS_TOKEN \
    -d "{\"encrypted_value\":\"$ACCESS_TOKEN\"}"