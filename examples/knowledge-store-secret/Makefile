SOLUTION_NAME := ${USER}awscreds

# Define a default goal.
default: test

# Validate target to check solution files are correct.
fork:
	@echo "forking solution..."
	fsoc solution fork --source-dir=package ${SOLUTION_NAME} --verbose
	@echo "Solution forked."


# Validate target to check solution files are correct.
.PHONY: validate
validate:
	@echo "Validating solution..."
	fsoc solution validate --directory ${SOLUTION_NAME} --tag=base -v
	@echo "Solution validated."

# Push target to deploy your solution.
push:
	@echo "Pushing solution..."
	fsoc solution push --directory ${SOLUTION_NAME} --tag=base
	@echo "Solution pushed."

status:
	@echo "Checking status..."
	fsoc solution status ${USER}malware --tag=base
	@echo "Status checked."


# Test target that needs to run fork and local validation
test:
	@echo "to be implemented"

clean:
	@test -d ./"${SOLUTION_NAME}" && rm -r ./"${SOLUTION_NAME}" || echo "nothing to clean"

# Test which require fsoc tenant set up
integration_test: clean fork validate
	@echo "Running custom tests..."
	@test -d ./"${SOLUTION_NAME}" && rm -r ./"${SOLUTION_NAME}" || echo "nothing to clean"
	@echo "Custom tests completed."
