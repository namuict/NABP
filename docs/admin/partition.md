# Partition Table

## 1. Overview

Partition Table은 NABP에서  
**OS 설치 시 디스크 파티션 구조를 정의하는 구성 요소**입니다.

Partition 설정은 OS 설치 과정에서 가장 먼저 적용되며,  
디스크 초기화 방식, 파티션 구성, 파일 시스템 유형을 결정합니다.

Partition Table은  
Installation Media 이후, Provisioning Workflow 이전에 설정됩니다.

---

## 2. Role of Partition Table

Partition Table은 다음 역할을 수행합니다.

- OS 설치 시 디스크 초기화 방식 정의
- 파티션 구성 및 파일 시스템 설정
- Diskfull / Diskless 설치 방식 결정
- OS 설치 안정성 및 성능에 영향

Partition 설정 오류는  
OS 설치 실패로 직결될 수 있습니다.

---

## 3. Configuration Path

Partition Table은 다음 경로에서 설정합니다.

Workflow  
→ Partition Tables

---

## 4. Partition Table Creation Flow

Partition Table 생성은 다음 순서로 진행됩니다.

1. OS Family 선택
2. Partition Template 선택 또는 생성
3. Template 내용 정의
4. 저장 및 적용

기본 제공 Template을 사용하거나  
기존 Template을 복제하여 수정할 수 있습니다.

---

## 5. Partition Template Types

NABP는 OS 계열에 따라  
다음과 같은 Partition Template을 지원합니다.

- Kickstart 기반 (RedHat 계열)
- Preseed 기반 (Debian / Ubuntu 계열)

---

## 6. Default Partition Template

NABP 기본 Partition Template은  
모든 기존 파티션을 삭제하고  
시스템에 필요한 파티션을 자동으로 생성합니다.

예시 (Kickstart):

- 모든 디스크 초기화
- 자동 파티셔닝 수행
- LVM 기반 파티션 구성

기본 Template은  
대부분의 일반적인 Diskfull 설치에 적합합니다.

---

## 7. Custom Partition Template

사용자는 직접 Partition Template을 작성할 수 있습니다.

Custom Template을 통해 다음이 가능합니다.

- 특정 디스크 지정
- 파티션 크기 수동 설정
- 파일 시스템 유형 지정
- RAID / LVM 구성
- Swap 파티션 정의

Custom Template은  
충분한 테스트 후 사용해야 합니다.

---

## 8. Diskfull vs Diskless Considerations

### 8.1 Diskfull Installation

- 로컬 디스크에 OS 설치
- Partition Table 필수
- 일반적인 서버 환경에 적합

---

### 8.2 Diskless Installation

- OS를 메모리 또는 네트워크 기반으로 실행
- Partition Table 사용 제한적
- Compute Node 환경에 적합

Diskless 환경에서는  
Partition Template이 OS 설치보다는  
초기 부팅 및 tmpfs 구성에 영향을 미칩니다.

---

## 9. Usage with Operating System

Partition Table은  
Operating System 정의 시 선택됩니다.

- OS는 Partition Table을 참조
- Machine Group은 OS 설정을 상속
- 배포 시 동일한 Partition 구조 적용

Partition 변경 시  
해당 OS 및 Machine Group에 영향을 미칩니다.

---

## 10. Best Practices

- OS 버전별 Partition Template 분리
- Production / Test 환경 분리
- Default Template 사용 후 필요 시 커스터마이징
- RAID / LVM 설정 시 사전 검증
- Diskless 환경은 별도 Template 관리

---

## 11. Common Issues

- 잘못된 디스크 디바이스 지정
- 파티션 크기 충돌
- 파일 시스템 미지원
- Diskless 환경에 Diskfull Template 적용

문제 발생 시  
Partition Template 내용을 우선적으로 점검해야 합니다.

---

## 12. Related Configuration

Partition Table은 다음 구성 요소와 연관됩니다.

- Installation Media
- Operating System
- Provisioning Workflow
- Machine Group

