FROM maven:3.6.3-ibmjava-8-alpine as builder
WORKDIR /build
ADD acceptance_container /build/acceptance_container
RUN cd /build/acceptance_container && mvn clean package

FROM ibmjava:8-sdk-alpine
WORKDIR /test
COPY --from=builder /build/acceptance_container/target/acceptance-test.jar /test/lib/
COPY --from=builder /build/acceptance_container/target/dependency/* /test/lib/
COPY --from=builder /build/acceptance_container/src/main/resources/* /test/features/
ENTRYPOINT java -ea -cp "/test/lib/*" cucumber.api.cli.Main --add-plugin de.monochromata.cucumber.report.PrettyReports:/test/cucumber --glue com.acceptance /test/features/
