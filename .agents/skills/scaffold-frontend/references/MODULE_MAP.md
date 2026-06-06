# Reference — KMP module map & feature recipe

## Package convention

Root package: `com.<org>.<product>` (e.g. `com.albert.myfinance`). Keep the same
root across `shared` and `composeApp` so DI and navigation stay simple.

## The "add a feature" recipe (always this order)

Suppose the feature is **Transactions**.

1. **Domain model** — `shared/domain/model/Transaction.kt` (plain data class).
2. **Repository interface** — `shared/domain/repository/TransactionRepository.kt`.
3. **Use case(s)** — `shared/domain/usecase/GetTransactionsUseCase.kt`,
   `AddTransactionUseCase.kt`. One responsibility each.
4. **DTO** — `shared/data/remote/dto/TransactionDto.kt` (`@Serializable`, mirrors
   the Supabase row exactly: snake_case columns, nullable where the DB is).
5. **Mapper** — `shared/data/mapper/TransactionMapper.kt` (`toDomain`/`toDto`).
6. **DataSource** — `shared/data/remote/datasource/SupabaseTransactionDataSource.kt`
   (uses the supabase-kt client; does the RLS-scoped query).
7. **Repository impl** — `shared/data/repository/TransactionRepositoryImpl.kt`.
8. **DI wiring** — register impl in `dataModule`, use cases in `domainModule`.
9. **UiState** — `composeApp/presentation/transactions/TransactionsUiState.kt`.
10. **ViewModel** — `TransactionsViewModel.kt` (exposes `StateFlow<UiState>`,
    handles events, calls use cases). Register in `AppModule`.
11. **Screen** — `TransactionsScreen.kt` built from **design-bridge catalog components
    and tokens only** (no hardcoded colors/dimens).
12. **Navigation** — add a `Screen.Transactions` entry + route.

## Layering checks (fail the review if violated)

- A file in `composeApp` importing anything from `shared/data/**` → ❌.
- A `usecase` importing a `*RepositoryImpl` → ❌.
- A `domain/model` with `@Serializable` / `androidx.*` / `kotlinx.serialization` → ❌.
- A Composable reading `Color(0xFF...)` or a raw `.dp` literal for spacing → ❌
  (use the theme/tokens). See `design-tokens` rule.

## DI module shape (Koin)

```kotlin
// shared/di/SharedModule.kt
val dataModule = module {
    single { SupabaseClientProvider.create(get()) }
    single<TransactionRepository> { TransactionRepositoryImpl(get()) }
}
val domainModule = module {
    factory { GetTransactionsUseCase(get()) }
    factory { AddTransactionUseCase(get()) }
}
val sharedModules = listOf(supabaseModule, dataModule, domainModule)

// composeApp/di/AppModule.kt
val appModule = module {
    viewModel { TransactionsViewModel(get(), get()) }
}
val allModules = sharedModules + appModule
```

## Navigation (adaptive)

```kotlin
sealed interface Screen {
    data object Home : Screen
    data object Transactions : Screen
    data object Settings : Screen
}
```

`AdaptiveScaffold` switches between `NavigationBar` (Compact) and
`NavigationRail`/permanent drawer (Expanded) based on `WindowSizeClass`.
