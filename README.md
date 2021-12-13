Code that powers [aoc.ryoung.info](https://aoc.ryoung.info)

![screen shot](https://github.com/ryoung786/AdventOfCode/blob/main/site_screenshot.png)

# Usage
## Solving
- To run your code for a particular day: `$ mix solve -y <year> -d <day>`
- Or just part 1: `$ mix solve -y <year> -d <day> -p 1`
- Or just part 2: `$ mix solve -y <year> -d <day> -p 2`
## Generate new files
- To generate a new year: `$ mix gen_year <year>`
- To generate a single new day: `$ mix gen_day -y <year> -d <day>`
These tasks will generate a solution file, a test file, and a file to paste the input.
# Tests
`$ mix test` runs all tests
# Deploying to Production
A push to the `main` branch will trigger a Github Action [workflow](https://github.com/ryoung786/AdventOfCode/blob/main/.github/workflows/main.yml) that will run the tests, and if successful, will deploy to heroku.  Upon a successful deploy, you may access the site at [aoc.ryoung.info](https://aoc.ryoung.info)
