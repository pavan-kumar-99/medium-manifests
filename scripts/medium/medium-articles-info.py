import os
import requests
import json
from medium_api import Medium

api_key = os.getenv('API_KEY')

medium = Medium(api_key)

user = medium.user(username="pavan1999-kumar")

user.fetch_articles()

articles_data = []

for article in user.articles:
    article_data = {
        "article_id": article.article_id,
        "title": article.title,
        "url": article.url
    }
    articles_data.append(article_data)

json_data = json.dumps(articles_data, indent=4)

print(json_data)
