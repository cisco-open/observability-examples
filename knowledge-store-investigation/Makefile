.PHONY: fork validate

# Define a default goal.
default: test

# Validate target to check solution files are correct.
fork:
	@echo "forking solution..."
	./fork.sh
	@echo "Solution forked."


# Validate target to check solution files are correct.
validate:
	@echo "Validating solution..."
	./validate.sh
	@echo "Solution validated."

# Push target to deploy your solution.
push:
	@echo "Pushing solution..."
	./push.sh
	@echo "Solution pushed."

# Test target that runs fork, validate, and push.
test: fork validate
	@echo "All tests and deployments have been successfully executed."

# Custom test target if you have a specific script for testing.
custom_test:
	@echo "Running custom tests..."
	# Replace this with your custom test command/script.
	@echo "Custom tests completed."
