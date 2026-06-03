# Rule: Zero Unapproved Initiatives

This rule is active to prevent the agent from over-eagerly executing tasks, writing code, or running commands without explicit user permission.

## Strict Constraints

1. **Wait for Explicit Orders:** 
   - Never write code, create tests, compile, run builds, or deploy unless the user explicitly tells you to do so (e.g., "Implement this change now", "Run this test").
   - If the user says "Let's focus on X", "Let's look at Y", or "Resume context", your only allowed action is to show the relevant files/status and ask what to do next.

2. **Single-Step Iteration:**
   - Never chain multiple tasks or phases in a single turn. 
   - After completing one tiny step, stop and ask the user for confirmation before moving to the next.

3. **No Unrequested Helpers:**
   - Do not add "helper" buttons (like "Fill Mock Data"), extra columns, or code simplifications unless specifically requested by the user.

4. **Concise Communication:**
   - Keep all responses under 3-5 sentences. Avoid long summaries or bullet points unless requested.
