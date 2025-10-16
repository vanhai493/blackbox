import json
from dataclasses import dataclass
from typing import Dict, Optional
from urllib.error import HTTPError, URLError
from urllib.parse import urljoin
from urllib.request import Request, urlopen


@dataclass
class SimpleResponse:
    status_code: int
    text: str
    headers: Dict[str, str]

    def json(self) -> Optional[Dict]:
        try:
            return json.loads(self.text)
        except json.JSONDecodeError:
            return None


class RequestsLibrary:
    def __init__(self) -> None:
        self._sessions: Dict[str, Dict[str, Dict[str, str]]] = {}

    def create_session(self, alias: str, url: str, headers: Optional[Dict[str, str]] = None) -> None:
        base_url = url.rstrip("/")
        session_headers = dict(headers or {})
        self._sessions[alias] = {"base_url": base_url, "headers": session_headers}

    def post_on_session(
        self,
        alias: str,
        uri: str,
        json: Optional[Dict] = None,
        headers: Optional[Dict[str, str]] = None,
    ) -> SimpleResponse:
        return self._perform_request(alias, uri, "POST", json=json, headers=headers)

    def get_on_session(
        self,
        alias: str,
        uri: str,
        headers: Optional[Dict[str, str]] = None,
    ) -> SimpleResponse:
        return self._perform_request(alias, uri, "GET", headers=headers)

    def status_should_be(self, response: SimpleResponse, expected_status: int) -> None:
        expected = int(expected_status)
        actual = int(response.status_code)
        if actual != expected:
            raise AssertionError(
                f"Expected status code {expected} but received {actual}.\nResponse body:\n{response.text}"
            )

    def _perform_request(
        self,
        alias: str,
        uri: str,
        method: str,
        json: Optional[Dict] = None,
        headers: Optional[Dict[str, str]] = None,
    ) -> SimpleResponse:
        session = self._get_session(alias)
        base_url = session["base_url"]
        target_url = urljoin(f"{base_url}/", uri.lstrip("/"))
        request_headers = dict(session["headers"])
        if headers:
            request_headers.update(headers)

        data_bytes = None
        if json is not None:
            data_bytes = json.dumps(json).encode("utf-8")
            request_headers.setdefault("Content-Type", "application/json")

        request = Request(target_url, data=data_bytes, headers=request_headers, method=method)

        try:
            with urlopen(request) as response:
                body = response.read().decode("utf-8")
                status_code = response.getcode()
                response_headers = dict(response.headers.items())
                return SimpleResponse(status_code=status_code, text=body, headers=response_headers)
        except HTTPError as error:
            body = error.read().decode("utf-8", errors="ignore")
            response_headers = dict(error.headers.items()) if error.headers else {}
            return SimpleResponse(status_code=error.code, text=body, headers=response_headers)
        except URLError as error:
            raise AssertionError(f"Request to {target_url} failed: {error.reason}") from error

    def _get_session(self, alias: str) -> Dict[str, Dict[str, str]]:
        if alias not in self._sessions:
            raise AssertionError(f"Session with alias '{alias}' has not been created.")
        return self._sessions[alias]
