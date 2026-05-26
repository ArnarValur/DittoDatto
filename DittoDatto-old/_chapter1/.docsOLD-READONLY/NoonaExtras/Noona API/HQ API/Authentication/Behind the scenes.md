---
tag: "noona.is"
---
[Authentication](https://docs.noona.is/docs/authentication) [OAuth 2.0](https://docs.noona.is/docs/authentication/oauth)

---

As we saw in the previous section the user experience is excellent. But what is happening behind the scenes?

Let's use the **Blacklist** app from the previous section as an example.

In the ***traditional OAuth flow*** the story goes like this:

There exists a system, **Blacklist**, that wants to create some integration with an external system, that is also an OAuth provider, like Noona.

A user that is logged into, and viewing, the Blacklist system then goes thought the following steps:

Then there is the ***reverse approach*** which goes like this:

A user that is logged into Noona navigates to the App Store and sees an app called **Blacklist**

1. The user presses **Install**.
2. The user sees the **consent screen**.
3. The user clicks "Approve" and is **redirected to Blacklist** with an **authorization code**.
4. Blacklist uses this **authorization code** to get a **refresh token** and an **access token** for the Noona user.
5. Blacklist can now do a number of things:
	- If Blacklist is only a simple app that has no purpose outside of its Noona use case. \[**Blacklist actually fits in this category**\]
		- It onboards the user and shows him a screen that explains how the app works.
		- Shows a button that redirects the user back to Noona.
	- If Blacklist is a fully fledged software system more complex flows are available, but at a bear minimum it has to **authenticate** the user within Blacklist.

In the traditional OAuth flow a **state variable** is sent by Blacklist into the flow that survives all the redirect loops and eventually shows up back in Blacklist with the authorization code. This state variable is used to identify the user that started the flow and to pair him with the authorization code and eventually refresh/access tokens.

Since the **reverse approach** begins within Noona, there is no state variable and the integration must support an authentication step at the end. Given that the app is an integration with a " *fully fledged software system* ".

But for simple apps that have no purpose outside of Noona. This is, as the name suggest, simpler.

Visit our [**App Store Section**](https://docs.noona.is/docs/app-store) for complete guides on creating an App and the **reverse OAuth flow** - or continue to implement a traditional OAuth flow that originates from your system.[User's Perspective](https://docs.noona.is/docs/authentication/oauth/users-perspective)

[

Implementing

](https://docs.noona.is/docs/authentication/oauth/implementing)