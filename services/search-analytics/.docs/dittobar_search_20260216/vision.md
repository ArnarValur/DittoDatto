> This is a human mental model of the DittoBar search component.

# Dittobar - Ditto's eyes are your eyes

## The High-Level

The Dittobar is the Users interaction bar with the agent Ditto, here the User can either type or speak using the device microphone.

I foresee already that this SearchBar will be a custom designed UI component, hopefully we're able to "Disect" the Nuxt UI Search Bar into fine bits 'n details.

The search results you ask? Simply... "Simply" haha.. A2NUI :) -> context/\* here is recent documents from A2NUI laboratory.
When the bar is searching and finds the first and nearest, I want the map to move there, and Ditto can create a SearchModal which we'll create in the laboratory (This is all conceptual right now, and we are not going to finish this all by the showcase tomorrow, but this is the vision(I think :D))

## The Medium-Level

We have 3 states for the search bar: (Inspect: ./DittoSearchbar.jpg)

1. Standard SearchBar
2. Inquiring Information
3. Results, The nearest establishment in the category the user is looking for.

## The Low-Level

Here we need to see our options, because this is a long-track, I want to start with high and medium level conceptualization, and your expertese in the system design itself, whether this is doable with A2NUI or not...
