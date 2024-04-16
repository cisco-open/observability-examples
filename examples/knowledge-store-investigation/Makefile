.PHONY: validate

# Define a default goal.
default: test

# Validate target to check solution files are correct.
fork:
	@echo "forking solution..."
	fsoc solution fork --source-dir=package ${USER}malware --verbose
	@echo "Solution forked."


# Validate target to check solution files are correct.
validate:
	@echo "Validating solution..."
	fsoc solution validate --directory ${USER}malware --tag=base -v
	@echo "Solution validated."

# Push target to deploy your solution.
push:
	@echo "Pushing solution..."
	fsoc solution push --directory ${USER}malware --tag=base
	@echo "Solution pushed."

# Test target that runs fork, validate, and push.
test: clean fork validate
	@echo "All tests and deployments have been successfully executed."

clean:
	@test -d ./"${USER}malware" && rm -r ./"${USER}malware" || echo "nothing to clean"

# Custom test target if you have a specific script for testing.
custom_test:
	@echo "Running custom tests..."
	# Replace this with your custom test command/script.
	@echo "Custom tests completed."
